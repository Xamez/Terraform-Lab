output "vpc_id" {
  value = data.aws_vpc.lab.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

output "public_security_group_id" {
  value = aws_security_group.public.id
}

output "internal_security_group_id" {
  value = aws_security_group.internal.id
}

output "nginx_target_group_arn" {
  value = aws_lb_target_group.nginx.arn
}

output "tomcat_target_group_arn" {
  value = aws_lb_target_group.tomcat.arn
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
