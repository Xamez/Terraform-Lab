output "nginx_asg_name" {
  value = module.asg_nginx.asg_name
}

output "tomcat_asg_name" {
  value = module.asg_tomcat.asg_name
}
