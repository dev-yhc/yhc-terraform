terraform {
  source = "${get_parent_terragrunt_dir()}/../../../../modules/vpc"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  name            = "test"
  cidr            = "10.2.0.0/16"
  azs             = ["ap-northeast-2a"]
  public_subnets  = ["10.2.0.0/20"]
  private_subnets = ["10.2.48.0/20"]

  tags = {
    Stack   = "dev"
    Role    = "network"
    Product = "yhc"
    Managed = "terraform"
  }
}