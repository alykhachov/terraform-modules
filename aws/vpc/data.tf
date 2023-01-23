data "aws_vpc_endpoint_service" "s3" {
  count        = var.s3_endpoint ? 1 : 0
  service      = "s3"
  service_type = "Gateway"
}
data "aws_route53_zone" "service_domain" {
  name         = "${var.service_domain}."
  private_zone = true
}

data "aws_vpc" "sameregion_peer" {
  count = var.sameregion_peer_vpc_id != "" ? 1 : 0
  id    = var.sameregion_peer_vpc_id
}

data "aws_route_tables" "sameregion_peer" {
  count  = var.sameregion_peer_vpc_id != "" ? 1 : 0
  vpc_id = var.sameregion_peer_vpc_id
}
