output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "ssh_connection_command" {
  value = "ssh ec2-user@${aws_instance.bastion.public_ip}"
}

output "bastion_security_group_id" {
  value = aws_security_group.bastion.id
}

output "student_a_rds_security_group_id" {
  value = data.aws_security_group.rds.id
}

output "db_host_from_ssm" {
  value     = data.aws_ssm_parameter.db_host.value
  sensitive = true
}
