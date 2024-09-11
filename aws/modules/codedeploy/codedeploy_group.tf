#
# CodeDeploy Deployment Group
#
resource "aws_codedeploy_deployment_group" "this" {
  app_name               = aws_codedeploy_app.app.name
  deployment_group_name  = "${aws_codedeploy_app.app.name}-deployment-group"
  deployment_config_name = var.deployment_config_name
  service_role_arn       = aws_iam_role.codedeploy-role.arn

  dynamic "ec2_tag_set" {
    for_each = var.ec2_tag_set
    content {
      dynamic "ec2_tag_filter" {
        for_each = ec2_tag_set.value
        content {
          key   = ec2_tag_filter.value.key
          type  = ec2_tag_filter.value.type
          value = ec2_tag_filter.value.value
        }
      }
    }
  }

}