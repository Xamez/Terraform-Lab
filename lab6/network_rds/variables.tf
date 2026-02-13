variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

variable "name_prefix" {
  description = "Prefix for Lab 6 resources"
  type        = string
  default     = "student-16-10-lab6"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "labdb"
}

variable "db_username" {
  description = "Database admin username"
  type        = string
  default     = "labadmin"
}

variable "db_password" {
  description = "Database admin password"
  type        = string
  sensitive   = true
}

variable "bastion_security_group_id" {
  description = "Security group ID created by Student B for bastion access"
  type        = string
  default     = null
}
