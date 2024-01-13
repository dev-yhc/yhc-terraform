provider "ncloud" {
  support_vpc = true
  region      = "KR"
  access_key  = var.access_key
  secret_key  = var.secret_key
}

# VPC
resource "ncloud_vpc" "yhc-prod-kr1-vpc" {
  name            = var.vpc_name
  ipv4_cidr_block = "10.0.0.0/16"
}

# Public Subnet
resource "ncloud_subnet" "public" {
  name           = "${var.vpc_name}-public"
  vpc_no         = ncloud_vpc.yhc-prod-kr1-vpc.vpc_no
  subnet         = cidrsubnet(ncloud_vpc.yhc-prod-kr1-vpc.ipv4_cidr_block, 8, 0) // "10.0.0.0/24"
  zone           = "KR-2"
  network_acl_no = ncloud_network_acl.network_acl_02_public.id
  subnet_type    = "PUBLIC" // PUBLIC(Public)
}
# Private Subnet
resource "ncloud_subnet" "private" {
  name           = "${var.vpc_name}-private"
  vpc_no         = ncloud_vpc.yhc-prod-kr1-vpc.vpc_no
  subnet         = cidrsubnet(ncloud_vpc.yhc-prod-kr1-vpc.ipv4_cidr_block, 8, 1) // "10.0.1.0/24"
  zone           = "KR-2"
  network_acl_no = ncloud_network_acl.network_acl_02_private.id
  subnet_type    = "PRIVATE" // PRIVATE(Private)
}

# Network ACL
resource "ncloud_network_acl" "network_acl_02_public" {
  vpc_no = ncloud_vpc.yhc-prod-kr1-vpc.id
  name   = "${var.vpc_name}-public"
}
resource "ncloud_network_acl" "network_acl_02_private" {
  vpc_no = ncloud_vpc.yhc-prod-kr1-vpc.id
  name   = "${var.vpc_name}-private"
}