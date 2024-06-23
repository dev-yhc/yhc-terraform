terraform {
  source = "${get_parent_terragrunt_dir()}/../../../../modules/vpc"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  name            = "yhc-dev-an2-vpc"
  cidr            = "10.2.0.0/16"
  azs             = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c", "ap-northeast-2d"]
  public_subnets  = ["10.2.0.0/20", "10.2.16.0/20", "10.2.32.0/20", "10.2.112.0/20"]
  private_subnets = ["10.2.48.0/20", "10.2.64.0/20", "10.2.80.0/20", "10.2.96.0/20"]

  single_nat_gateway   = true
  enable_nat_gateway   = true

  tags = {
    Stack   = "dev"
    Role    = "network"
    Product = "yhc"
    Managed = "terraform"
  }
}