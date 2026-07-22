output "cluster_id" {
  value = aws_ecs_cluster.main.id
}

output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "execution_role_arn" {
  value = aws_iam_role.ecs_execution.arn
}

output "task_role_arn" {
  value = aws_iam_role.ecs_task.arn
}

output "app_security_group_id" {
  description = "inputting this in the rds module's allowed_security_group_ids to finally close the Day 2 gap"
  value       = aws_security_group.ecs_app.id
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.ecs_app.name
}

output "scalable_target_resource_id" {
  value = aws_appautoscaling_target.ecs.resource_id
}