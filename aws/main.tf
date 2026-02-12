terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-agvq0"
    key            = "global/s3/student_16/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.instance_region
}

resource "aws_key_pair" "deploy-key" {
  key_name   = "deploy-key-maxence"
  public_key = file("${path.module}/.ssh/aws.pub")
}

resource "aws_security_group" "terraform-sg" {
  name   = "ssh-sg-maxence"
  vpc_id = var.instance_vpc
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  description       = "Allow SSH"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.terraform-sg.id
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  security_group_id = aws_security_group.terraform-sg.id
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_launch_template" "asg_template" {
  name_prefix   = "maxence-template-"
  image_id      = data.aws_ami.selected.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.deploy-key.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.terraform-sg.id]
    delete_on_termination       = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.instance_name}-${terraform.workspace}"
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  name_prefix         = "asg-maxence-"
  desired_capacity    = var.instance_desired_capacity
  max_size            = var.instance_max_size
  min_size            = var.instance_min_size
  wait_for_capacity_timeout = "0"
  vpc_zone_identifier = [data.aws_subnet.selected.id]

  launch_template {
    id      = aws_launch_template.asg_template.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "selected" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["*al2023-ami-2023.*-kernel-6.12-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_subnet" "selected" {
  vpc_id            = aws_security_group.terraform-sg.vpc_id
  availability_zone = "${var.instance_region}c"
}
