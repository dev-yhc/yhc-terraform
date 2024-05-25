provider "aws" {
  region                 = var.aws_region
  profile                = var.aws_profile
  skip_region_validation = true
}

######
# VPC
######
resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  cidr_block                       = var.cidr
  # instance_tenancy                 = var.instance_tenancy
  # enable_dns_hostnames             = var.enable_dns_hostnames
  # enable_dns_support               = var.enable_dns_support
  assign_generated_ipv6_cidr_block = var.enable_ipv6

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    var.vpc_tags,
  )
}