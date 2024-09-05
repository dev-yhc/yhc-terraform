module "single_instance" {
  source = "../../../../modules/ec2"
  name = "pulling_single_instance"
  key_name = "pulling_single_instance_key"
  instance_type = "t2.small"
  subnet_id = data.terraform_remote_state.vpc.outputs.public_subnets_id_by_az["ap-northeast-2a"]

  tags = {
    stack   = "prod"
    product = "pulling"
    managed = "terraform"
  }
}