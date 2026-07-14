output "secret_arns" {
  value = { for k, v in aws_secretsmanager_secret.app_secrets : k => v.arn }
}

output "database_url_secret_arn" {
  description = "for ECS task definition's DATABASE_URL secret"
  value       = aws_secretsmanager_secret.database_url.arn
}