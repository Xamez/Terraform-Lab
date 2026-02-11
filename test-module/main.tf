terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

module "nginx" {
  source          = "git::https://github.com/Xamez/Terraform-Lab.git//src"
  container_count = 1
}