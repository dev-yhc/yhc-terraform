resource "aws_codedeploy_app" "app" {
  compute_platform = var.compute_platform
  name             = var.app_name
  tags             = var.tags
}