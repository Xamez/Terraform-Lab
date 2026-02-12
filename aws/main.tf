terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

resource "aws_key_pair" "deploy-key" {
  key_name   = "deploy-key"
  public_key = file("${path.module}/.ssh/aws.pub")
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
  ami                    = data.aws_ami.selected.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet.selected.id
  key_name               = aws_key_pair.deploy-key.key_name
  vpc_security_group_ids = [aws_security_group.terraform-sg.id]

  tags = {
    Name = var.instance_name
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
  vpc_id = aws_security_group.terraform-sg.vpc_id
  availability_zone = "eu-west-3c"
}

output "public-dns" {
  value = aws_instance.vm.public_dns
}

output "vm-ip" {
  value = aws_instance.vm.public_ip
}