terraform {
  source = "${get_parent_terragrunt_dir()}/../../../../../modules/ecr"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  repository_name = "clip"
  repository_type = "private"
  repository_encryption_type = "AES256"

  registry_scan_type = "BASIC"

  repository_read_write_access_arns = []

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          "tagStatus": "untagged",
          countType     = "imageCountMoreThan",
          countNumber   = 10
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    stack   = "prod"
    role    = "network"
    managed = "terraform"
  }
}