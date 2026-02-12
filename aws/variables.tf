variable "instance_vpc" {
  description = "VPC of VM instance to deploy"
  type        = string
  default     = "vpc-083052666da04fb53"
}

variable "instance_region" {
  description = "Region of VM instance to deploy"
  type        = string
  default     = "eu-west-3"
}

variable "instance_type" {
  description = "The type of VM instance to deploy"
  type        = string
  default     = "t3.micro"
}

variable "instance_name" {
  description = "Name of the VM instance to deploy"
  type        = string
  default     = "VM Maxence"
}

variable "instance_min_size" {
  description = "Minimum number of instances in the Auto Scaling group"
  type        = number
  default     = 1
}

variable "instance_max_size" {
  description = "Maximum number of instances in the Auto Scaling group"
  type        = number
  default     = 3
}

variable "instance_desired_capacity" {
  description = "Desired number of instances in the Auto Scaling group"
  type        = number
  default     = 1
}
