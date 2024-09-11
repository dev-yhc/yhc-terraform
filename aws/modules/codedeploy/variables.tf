

### code deploy app
variable "app_name" {
  description = "app name"
  type        = string
  default     = null
}

variable "data_bucket_name" {
  description = "code deploy s3 bucket name"
  type        = string
  default     = null
}

variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}

variable "compute_platform" {
  description = "compute platform(ECS, on-premise...)"
  type        = string
  default     = null
}

variable "deployment_config_name" {
  description = "config name (CodeDeployDefault.AllAtOnce)"
  type = string
  default = null
}

variable "auto_rollback_configuration" {
  description = "auto_rollback_configuration"
  type        = map(string)
  default     = {}
}

# variable "ec2_tag_set" {
#   description = "ec2_tag_set"
#   type        = map(string)
#   default     = {}
# }

variable "ec2_tag_set" {
  type = list(list(object({
    key   = string
    type  = string
    value = string
  })))
  default = []
}