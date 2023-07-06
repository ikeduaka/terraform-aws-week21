variable "name" {
  description = "Name used across the resources created"
  type        = string
}

variable "launch_template" {
  description = "Name of an existing launch template to be used (created outside of this module)"
  type        = string
  default     = null
}

#variable "target_group_arns" {
  #description = "A set of `aws_alb_target_group` ARNs, for use with Application or Network Load Balancing"
  #type        = list(string)
  #default     = []
#}
variable "subnets" {
  description = "A list of subnets to associate with the autoscaling"
  type        = list(string)
  default     = null
}