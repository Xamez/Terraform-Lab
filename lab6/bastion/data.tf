data "aws_caller_identity" "current" {}

data "aws_vpc" "lab" {
  filter {
    name   = "tag:Name"
    values = ["Lab5-6"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.lab.id]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

data "aws_ssm_parameter" "db_host" {
  name = "/lab6/db/host"
}

data "aws_ssm_parameter" "db_name" {
  name = "/lab6/db/name"
}

data "aws_ssm_parameter" "db_user" {
  name = "/lab6/db/user"
}

data "aws_security_group" "rds" {
  filter {
    name   = "group-name"
    values = [var.rds_security_group_name]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.lab.id]
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
