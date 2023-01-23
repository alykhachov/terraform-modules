data "aws_vpc_endpoint_service" "s3" {
  count        = var.s3_endpoint ? 1 : 0
  service      = "s3"
  service_type = "Gateway"
}
data "aws_route53_zone" "service_domain" {
  name         = "${var.service_domain}."
  private_zone = true
}