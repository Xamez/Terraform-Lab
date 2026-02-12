variable "name" {
  description = "ALB name"
  type        = string
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "subnet_ids" {
  description = "Public subnet ids"
  type        = list(string)
}

variable "security_group_ids" {
  description = "ALB security group ids"
  type        = list(string)
}

variable "nginx_tg_arn" {
  description = "Target group ARN for nginx"
  type        = string
}

variable "tomcat_tg_arn" {
  description = "Target group ARN for tomcat"
  type        = string
}
