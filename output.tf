output "rds_public_hostname" {
  value = aws_db_instance.postgres_db.address
}

output "rds_port" {
  value = aws_db_instance.postgres_db.port
}