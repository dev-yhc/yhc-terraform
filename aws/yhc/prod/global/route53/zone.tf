resource "aws_route53_zone" "pulling_in" {
  name    = "pulling.in"
  comment = "Managed by Terraform"
  force_destroy       = false


  tags = {
    stack   = "prod"
    product = "pulling_in"
    managed = "terraform"
  }
}