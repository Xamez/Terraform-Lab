output "asg_name" {
  value = aws_autoscaling_group.this.name
}

output "launch_template_id" {
  value = aws_launch_template.this.id
}

output "alb_dns_name" {
  value = var.create_alb ? aws_lb.this[0].dns_name : null
}
