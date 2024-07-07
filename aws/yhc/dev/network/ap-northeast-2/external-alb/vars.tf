####################
# General
####################
variable "tags" {
  default = {
    Duty    = "admin"
    Stack   = "dev"
    Role    = "external-alb"
    Product = "yhc"
    Managed = "Terraform"
  }
}

####################
# AWS Configure
####################
variable "aws_region" {
}
variable "aws_profile" {
}
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

####################
# Remote Data Source
####################
variable "remote_backend_bucket" {
  description = "remote_backend_bucket"
}
variable "remote_backend_bucket_region" {
  description = "remote_backend_bucket_region"
}
variable "remote_backend_bucket_profile" {
  description = "remote_backend_bucket_profile"
}
variable "vpc_remote_backend_bucket_key" {
  description = "vpc_remote_backend_bucket_key"
}
variable "sg_remote_backend_bucket_key" {
  description = "sg_remote_backend_bucket_key"
}
variable "org_prefix_list_remote_backend_bucket_key" {
  description = "org_prefix_list_remote_backend_bucket_key"
}