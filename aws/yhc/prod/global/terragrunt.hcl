terraform {
  extra_arguments "custom_vars" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "destroy",
      "refresh"
    ]
    arguments = [
      "-var", "aws_region=ap-northeast-2",
      "-var", "aws_profile=dev-yhc",
      "-var", "sg_remote_backend_bucket_key=tfstate/yhc/prod/network/ap-northeast-2/sg/terraform.tfstate",
      "-var", "vpc_remote_backend_bucket_key=tfstate/yhc/prod/network/ap-northeast-2/vpc/terraform.tfstate",
#       "-var", "org_prefix_list_remote_backend_bucket_key=tfstate/Management/mgmt/network/ap-northeast-2/prefix_list/terraform.tfstate",
      "-var", "remote_backend_bucket=yhc-global-tf-state",
      "-var", "remote_backend_bucket_region=ap-northeast-2",
      "-var", "remote_backend_bucket_profile=dev-yhc",
    ]
  }
}

remote_state {
  backend = "s3"
  config = {
    bucket = "yhc-global-tf-state"
    key = "tfstate/yhc/prod/global/ap-northeast-2/${path_relative_to_include()}/terraform.tfstate"
    region = "ap-northeast-2"
    encrypt = true
    // can lock via dynamodb
    // dynamodb_table = "tfstate-lock"
    profile = "dev-yhc"
  }
}
