module "external-alb" {
  source = "../../../../../modules/alb-nlb"

  name = "test"

  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = false
  
  vpc_id  = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets = [
    data.terraform_remote_state.vpc.outputs.public_subnets[0],
    data.terraform_remote_state.vpc.outputs.public_subnets[1]
  ]
}