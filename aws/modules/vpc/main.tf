provider "aws" {
  region                 = var.aws_region
  profile                = var.aws_profile
  skip_region_validation = true
}


locals {
  max_subnet_length = max(
    length(var.private_subnets),
    length(var.elasticache_subnets),
    length(var.database_subnets),
    length(var.redshift_subnets),
  )
  nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(var.azs) : local.max_subnet_length

  # Use `local.vpc_id` to give a hint to Terraform that subnets should be deleted before secondary CIDR blocks can be free!
  vpc_id = element(
    concat(
      aws_vpc.this.*.id,
      [""],
    ),
    0,
  )
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

###################
# Internet Gateway
###################
resource "aws_internet_gateway" "this" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    var.igw_tags,
  )
}

################
# Public subnet
################
resource "aws_subnet" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 && (false == var.one_nat_gateway_per_az || length(var.public_subnets) >= length(var.azs)) ? length(var.public_subnets) : 0

  vpc_id                          = local.vpc_id
  cidr_block                      = element(concat(var.public_subnets, [""]), count.index)
  availability_zone               = element(var.azs, count.index)
  map_public_ip_on_launch         = var.map_public_ip_on_launch
  assign_ipv6_address_on_creation = var.public_subnet_assign_ipv6_address_on_creation == null ? var.assign_ipv6_address_on_creation : var.public_subnet_assign_ipv6_address_on_creation

  ipv6_cidr_block = var.enable_ipv6 && length(var.public_subnet_ipv6_prefixes) > 0 ? cidrsubnet(aws_vpc.this[0].ipv6_cidr_block, 8, var.public_subnet_ipv6_prefixes[count.index]) : null

  tags = merge(
    {
      "Name" = format(
        "%s.${var.public_subnet_suffix}.%s",
        var.name,
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.public_subnet_tags,
  )
}

#################
# Private subnet
#################
resource "aws_subnet" "private" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id                          = local.vpc_id
  cidr_block                      = var.private_subnets[count.index]
  availability_zone               = element(var.azs, count.index)
  assign_ipv6_address_on_creation = var.private_subnet_assign_ipv6_address_on_creation == null ? var.assign_ipv6_address_on_creation : var.private_subnet_assign_ipv6_address_on_creation

  ipv6_cidr_block = var.enable_ipv6 && length(var.private_subnet_ipv6_prefixes) > 0 ? cidrsubnet(aws_vpc.this[0].ipv6_cidr_block, 8, var.private_subnet_ipv6_prefixes[count.index]) : null

  tags = merge(
    {
      "Name" = format(
        "%s.${var.private_subnet_suffix}.%s",
        var.name,
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.private_subnet_tags,
  )
}

resource "aws_db_subnet_group" "private" {
  count       = var.create_vpc && length(var.private_subnets) > 0 && var.create_database_subnet_group ? 1 : 0
  name        = format("%s-%s-%s-pri-sub-group", element(split("-", var.name), 0), element(split("-", var.name), 1), element(split("-", var.name), 2))
  description = "Private DB subnet group for ${var.name}"
  subnet_ids  = aws_subnet.private.*.id

  tags = merge(tomap({ "Name" : format("%s-db-sub-group", var.name) }), var.database_subnet_group_tags, var.tags)
}