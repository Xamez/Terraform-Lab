terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}

module "aws-test-module" {
  source          = "git::https://github.com/Xamez/Terraform-Lab.git//aws"
  instance_name = "VM Maxence - Module"
}