output "repository_url" {
  description = "Hands-off to DevOps for docker push and the ECS task definition image field"
  value       = aws_ecr_repository.app.repository_url
}

output "repository_arn" {
  value = aws_ecr_repository.app.arn
}

output "github_actions_role_arn" {
  description = "Hands-off to DevOps - goes into their GitHub Actions workflow YAML"
  value       = aws_iam_role.github_actions.arn
}

