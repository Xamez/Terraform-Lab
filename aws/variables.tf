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
