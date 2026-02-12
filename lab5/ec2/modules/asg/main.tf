locals {
  effective_target_group_arns = var.create_alb ? [aws_lb_target_group.this[0].arn] : var.target_group_arns
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.name_prefix}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = var.security_group_ids

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.name_prefix}-instance"
    }
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix               = "${var.name_prefix}-asg-"
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.subnet_ids
  wait_for_capacity_timeout = "0"
  target_group_arns         = local.effective_target_group_arns

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "this" {
  count              = var.create_alb ? 1 : 0
  name               = substr("${var.name_prefix}-alb", 0, 32)
  internal           = false
  load_balancer_type = "application"
  subnets            = var.alb_subnet_ids
  security_groups    = var.alb_security_group_ids
}

resource "aws_lb_target_group" "this" {
  count       = var.create_alb ? 1 : 0
  name        = substr("${var.name_prefix}-tg", 0, 32)
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "http" {
  count             = var.create_alb ? 1 : 0
  load_balancer_arn = aws_lb.this[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[0].arn
  }
}
