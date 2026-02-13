variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

variable "name_prefix" {
  description = "Prefix for Lab 6 bastion resources"
  type        = string
  default     = "student-16-10-lab6"
}

variable "rds_security_group_name" {
  description = "RDS security group name created by Student A"
  type        = string
  default     = "student-16-10-lab6-rds-sg"
}
