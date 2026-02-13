output "rds_security_group_id" {
  value = aws_security_group.rds.id
}

output "rds_security_group_name" {
  value = aws_security_group.rds.name
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.address
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.this.name
}
