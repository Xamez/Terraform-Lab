terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-agvq0"
    key            = "global/s3/student_16_16/network.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

data "aws_vpc" "lab" {
  filter {
    name   = "tag:Name"
    values = ["Lab5-6"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  student_id = "student_16_16"
  az_a       = data.aws_availability_zones.available.names[0]
  az_b       = data.aws_availability_zones.available.names[1]
}

resource "aws_subnet" "private" {
  vpc_id                  = data.aws_vpc.lab.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = local.az_a
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.student_id}_Private"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = data.aws_vpc.lab.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = local.az_a
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.student_id}_Public_a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = data.aws_vpc.lab.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = local.az_b
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.student_id}_Public_b"
  }
}

data "aws_internet_gateway" "igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.lab.id]
  }
}

resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "public" {
  name        = "student_16_16_public"
  description = "Public access for ALB"
  vpc_id      = data.aws_vpc.lab.id
}

resource "aws_vpc_security_group_ingress_rule" "public_http" {
  security_group_id = aws_security_group.public.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "public_https" {
  security_group_id = aws_security_group.public.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "public_all_out" {
  security_group_id = aws_security_group.public.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "internal" {
  name        = "student_16_16_internal"
  description = "Internal access from public SG only"
  vpc_id      = data.aws_vpc.lab.id
}

resource "aws_vpc_security_group_ingress_rule" "internal_http_from_public" {
  security_group_id            = aws_security_group.internal.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
  referenced_security_group_id = aws_security_group.public.id
}

resource "aws_vpc_security_group_ingress_rule" "internal_https_from_public" {
  security_group_id            = aws_security_group.internal.id
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
  referenced_security_group_id = aws_security_group.public.id
}

resource "aws_vpc_security_group_ingress_rule" "internal_tomcat_from_public" {
  security_group_id            = aws_security_group.internal.id
  ip_protocol                  = "tcp"
  from_port                    = 8080
  to_port                      = 8080
  referenced_security_group_id = aws_security_group.public.id
}

resource "aws_vpc_security_group_egress_rule" "internal_all_out" {
  security_group_id = aws_security_group.internal.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_lb_target_group" "nginx" {
  name        = "student-16-16-nginx-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.aws_vpc.lab.id

  health_check {
    protocol = "HTTP"
    path     = "/"
    matcher  = "200-399"
  }
}

resource "aws_lb_target_group" "tomcat" {
  name        = "student-16-16-tomcat-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.aws_vpc.lab.id

  health_check {
    protocol = "HTTP"
    path     = "/"
    matcher  = "200-399"
  }
}

module "alb" {
  source = "./modules/alb"

  name               = "student-16-16-alb"
  vpc_id             = data.aws_vpc.lab.id
  subnet_ids         = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  security_group_ids = [aws_security_group.public.id]
  nginx_tg_arn       = aws_lb_target_group.nginx.arn
  tomcat_tg_arn      = aws_lb_target_group.tomcat.arn
}
