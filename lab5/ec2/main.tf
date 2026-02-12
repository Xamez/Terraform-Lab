terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-agvq0"
    key            = "global/s3/student_16_16/ec2.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "terraform-state-agvq0"
    key    = "global/s3/student_16_16/network.tfstate"
    region = "eu-west-3"
  }
}

data "aws_subnet" "private" {
  id = data.terraform_remote_state.network.outputs.private_subnet_id
}

data "aws_security_group" "internal" {
  id = data.terraform_remote_state.network.outputs.internal_security_group_id
}

data "aws_lb_target_group" "nginx" {
  name = "student-16-16-nginx-tg"
}

data "aws_lb_target_group" "tomcat" {
  name = "student-16-16-tomcat-tg"
}

data "aws_ami" "nginx" {
  most_recent = true
  owners      = ["979382823631"]

  filter {
    name   = "name"
    values = ["bitnami-nginx-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "tomcat" {
  most_recent = true
  owners      = ["979382823631"] // ami-051cd067454249599

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "asg_nginx" {
  source = "./modules/asg"

  name_prefix        = "student-16-16-nginx"
  ami_id             = data.aws_ami.nginx.id
  instance_type      = "t3.micro"
  min_size           = 2
  max_size           = 2
  desired_capacity   = 2
  subnet_ids         = [data.aws_subnet.private.id]
  security_group_ids = [data.aws_security_group.internal.id]
  target_group_arns  = [data.aws_lb_target_group.nginx.arn]
}

module "asg_tomcat" {
  source = "./modules/asg"

  name_prefix        = "student-16-16-tomcat"
  ami_id             = data.aws_ami.tomcat.id
  instance_type      = "t3.micro"
  min_size           = 2
  max_size           = 2
  desired_capacity   = 2
  subnet_ids         = [data.aws_subnet.private.id]
  security_group_ids = [data.aws_security_group.internal.id]
  target_group_arns  = [data.aws_lb_target_group.tomcat.arn]
}
