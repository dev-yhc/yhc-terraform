terraform {
  source = "${get_parent_terragrunt_dir()}/../../../modules/codedeploy"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  app_name = "clip"
  compute_platform = "Server"
  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  ec2_tag_set = [
    [
      {
        key   = "name"
        type  = "KEY_AND_VALUE"
        value = "clip"
      }
    ]
  ]

  data_bucket_name = "clip-codedeploy-archive"

  tags = {
    stack   = "prod"
    role    = "network"
    product = "yhc"
    managed = "terraform"
  }
}

