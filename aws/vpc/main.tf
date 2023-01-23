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