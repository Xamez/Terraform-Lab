resource "aws_lb" "this" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = var.security_group_ids
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Use /nginx or /tomcat"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "nginx" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = var.nginx_tg_arn
  }

  condition {
    path_pattern {
      values = ["/nginx", "/nginx/*"]
    }
  }
}

resource "aws_lb_listener_rule" "tomcat" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = var.tomcat_tg_arn
  }

  condition {
    path_pattern {
      values = ["/tomcat", "/tomcat/*"]
    }
  }
}
