output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_instance_id" {
  value = aws_instance.bastion.id
}

output "session_manager_command" {
  value = "aws ssm start-session --target ${aws_instance.bastion.id} --region ${var.region}"
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
