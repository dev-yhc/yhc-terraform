data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = var.remote_backend_bucket
    key     = var.vpc_remote_backend_bucket_key
    region  = var.remote_backend_bucket_region
    profile = var.remote_backend_bucket_profile
  }
}

data "terraform_remote_state" "pullingin_domain" {
  backend = "s3"
  config = {
    bucket  = var.remote_backend_bucket
    key     = var.pullingin_domain_remote_backend_bucket_key
    region  = var.remote_backend_bucket_region
    profile = var.remote_backend_bucket_profile
  }
}

data "terraform_remote_state" "pullingin_image_s3" {
  backend = "s3"
  config = {
    bucket  = var.remote_backend_bucket
    key     = var.pullingin_image_s3_remote_backend_bucket_key
    region  = var.remote_backend_bucket_region
    profile = var.remote_backend_bucket_profile
  }
}