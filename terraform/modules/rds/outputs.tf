output "db_instance_id" {
  value = aws_db_instance.main.id
}

output "db_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "db_security_group_id" {
  value = aws_security_group.rds.id
}

output "master_user_secret_arn" {
  description = "ARN of the Secrets Manager secret AWS created for the master password"
  value       = aws_db_instance.main.master_user_secret[0].secret_arn
}