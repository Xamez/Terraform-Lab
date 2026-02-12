variable "name_prefix" {
  description = "Resource name prefix"
  type        = string
}

variable "ami_id" {
  description = "AMI id"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Optional key pair name"
  type        = string
  default     = null
}

variable "min_size" {
  description = "ASG min size"
  type        = number
}

variable "max_size" {
  description = "ASG max size"
  type        = number
}

variable "desired_capacity" {
  description = "ASG desired size"
  type        = number
}

variable "subnet_ids" {
  description = "Subnets where ASG instances are placed"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups for launch template"
  type        = list(string)
}

variable "target_group_arns" {
  description = "Target groups attached to ASG"
  type        = list(string)
  default     = []
}

variable "create_alb" {
  description = "Create ALB in front of ASG"
  type        = bool
  default     = false
}

variable "alb_subnet_ids" {
  description = "ALB subnet ids when create_alb is true"
  type        = list(string)
  default     = []
}

variable "alb_security_group_ids" {
  description = "ALB security group ids when create_alb is true"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC id when create_alb is true"
  type        = string
  default     = null
}
