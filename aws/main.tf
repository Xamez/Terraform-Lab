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

resource "aws_key_pair" "deploy-key" {
  key_name   = "deploy-key"
  public_key = file(".ssh/aws.pub")
}

resource "aws_security_group" "terraform-sg" {
  name        = "lab-ssh-sg"
  vpc_id      = "vpc-083052666da04fb53"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  description              = "Allow SSH"
  from_port                = 22
  to_port                  = 22
  ip_protocol              = "tcp"
  security_group_id        = aws_security_group.terraform-sg.id
  cidr_ipv4                = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  description              = "Allow all outbound traffic"
  ip_protocol              = "-1"
  security_group_id        = aws_security_group.terraform-sg.id
  cidr_ipv4                = "0.0.0.0/0"
}

resource "aws_instance" "vm" {
  ami                    = "ami-092c64119783c2f31"
  instance_type          = "t3.micro"
  subnet_id              = "subnet-0d2b7f8e860ab5e38"
  key_name               = aws_key_pair.deploy-key.key_name
  vpc_security_group_ids = [aws_security_group.terraform-sg.id]

  tags = {
    Name = "VM Maxence"
  }
}

output "vm-ip" {
  value = aws_instance.vm.public_ip
}