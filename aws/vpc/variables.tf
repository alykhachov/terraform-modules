variable "name" { type = string }
variable "cidr" { type = string }
variable "secondary_cidr_blocks" {
  type    = list(string)
  default = []
}
variable "azs" { type = list(string) }
variable "public_subnets" {
  type    = list(string)
  default = []
}
variable "private_subnets" {
  type    = list(string)
  default = []
}
variable "enable_dns_hostnames" {
  type    = bool
  default = false
}
variable "enable_nat_gateway" {
  type    = bool
  default = false
}
variable "single_nat_gateway" {
  type    = bool
  default = false
}
variable "one_nat_gateway_per_az" {
  type    = bool
  default = false
}
variable "tags" {
  type    = map(string)
  default = {}
}

variable "s3_endpoint" {
  type    = bool
  default = false
}

variable "service_domain" {
  type    = string
  default = null
}
