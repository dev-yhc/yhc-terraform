terraform {
  source = "${get_parent_terragrunt_dir()}/../../../../modules/codedeploy"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  app_name = "clip"
  compute_platform = "EC2"
  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  tags = {
    stack   = "prod"
    role    = "network"
    product = "yhc"
    managed = "terraform"
  }
}

