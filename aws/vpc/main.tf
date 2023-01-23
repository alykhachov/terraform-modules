module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.19.0"

  name = var.name
  cidr = var.cidr

  secondary_cidr_blocks = var.secondary_cidr_blocks

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_dns_hostnames   = var.enable_dns_hostnames
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  tags = var.tags
}

resource "aws_vpc_endpoint" "s3" {
  count             = var.s3_endpoint ? 1 : 0
  vpc_id            = module.vpc.vpc_id
  vpc_endpoint_type = "Gateway"
  route_table_ids   = flatten([module.vpc.intra_route_table_ids, module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])
  service_name      = data.aws_vpc_endpoint_service.s3[0].service_name

  tags = var.tags
}

resource "aws_route53_zone_association" "service_domain" {
  zone_id = data.aws_route53_zone.service_domain.zone_id
  vpc_id  = module.vpc.vpc_id
}

resource "aws_vpc_peering_connection" "sameregion_peer" {
  count       = var.sameregion_peer_vpc_id != "" ? 1 : 0
  peer_vpc_id = var.sameregion_peer_vpc_id
  vpc_id      = module.vpc.vpc_id
  auto_accept = true

  tags = var.tags
}

resource "aws_route" "this" {
  count = var.sameregion_peer_vpc_id != "" ? length(flatten([module.vpc.intra_route_table_ids, module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])) : 0

  route_table_id            = flatten([module.vpc.intra_route_table_ids, module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])[count.index]
  destination_cidr_block    = data.aws_vpc.sameregion_peer[0].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.sameregion_peer[0].id

}

resource "aws_route" "sameregion_peer" {
  count = var.sameregion_peer_vpc_id != "" ? length(data.aws_route_tables.sameregion_peer[0].ids) : 0

  route_table_id            = data.aws_route_tables.sameregion_peer[0].ids[count.index]
  destination_cidr_block    = module.vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.sameregion_peer[0].id
}
