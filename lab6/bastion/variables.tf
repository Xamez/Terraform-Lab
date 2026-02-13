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

variable "bastion_key_name" {
  description = "EC2 key pair name to create/manage"
  type        = string
  default     = "student-16-10-bastion"
}

variable "bastion_public_key_path" {
  description = "Path to SSH public key used for bastion access"
  type        = string
  default     = ".ssh/aws.pub"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH to bastion"
  type        = string
  default     = "0.0.0.0/0"
}

variable "rds_security_group_name" {
  description = "RDS security group name created by Student A"
  type        = string
  default     = "student-16-10-lab6-rds-sg"
}
