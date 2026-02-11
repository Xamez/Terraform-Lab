variable "container_image" {
  description = "The name of the Docker image to use for the container."
  type        = string
  default     = "nginx:latest"
}

variable "container_name" {
  description = "The name of the Docker container."
  type        = string
  default     = "nginx-container"
}

variable "container_memory" {
    description = "The amount of memory to allocate to the Docker container (in MB)."
    type        = number
    default     = 256

    validation {
        condition     = var.container_memory > 0
        error_message = "The memory allocation must be greater than 0."
    }
}

variable "container_privileged" {
    description = "Whether the Docker container should run in privileged mode."
    type        = bool
    default     = false
}

variable "container_count" {
    description = "The number of Docker containers to create."
    type        = number
    default     = 1
    
    validation {
        condition     = var.container_count >= 1
        error_message = "The number of containers must be greater than or equal to 1."
    }
}

variable "container_ports" {
    description = "The port of the first docker container to expose. Next ports will be calculated by incrementing the external port number."
    type        = number
    default     = 3000
    validation {
        condition     = var.container_ports > 0 && var.container_ports < 65536
        error_message = "The port number must be between 1 and 65535."
    }
}