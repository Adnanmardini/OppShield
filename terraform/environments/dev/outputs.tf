# --- VPC ---
output "vpc_id" {
  description = "VPC ID - DevOps needs this to deploy the app"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs - for the ALB"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs - for the application layer (ECS/EC2)"
  value       = module.vpc.private_subnet_ids
}

output "database_subnet_ids" {
  description = "Database subnet IDs - for RDS"
  value       = module.vpc.database_subnet_ids
}

output "nat_gateway_ip" {
  description = "NAT Gateway public IP - useful for allow-listing outbound traffic"
  value       = module.vpc.nat_gateway_ip
}

output "flow_log_group_name" {
  description = "CloudWatch log group for VPC Flow Logs - needed by Security for Wazuh integration"
  value       = module.vpc.flow_log_group_name
}

# --- RDS ---
output "db_instance_id" {
  description = "RDS instance identifier"
  value       = module.rds.db_instance_id
}

output "db_endpoint" {
  description = "RDS endpoint (host:port)"
  value       = module.rds.db_endpoint
}

output "db_security_group_id" {
  description = "RDS security group ID - DevOps needs to reference this when creating the app/ECS security group"
  value       = module.rds.db_security_group_id
}

output "master_user_secret_arn" {
  description = "ARN of the RDS auto-generated master password secret"
  value       = module.rds.master_user_secret_arn
}

# --- Secrets ---
output "app_secret_arns" {
  description = "ARNs for paystack-secret-key, paystack-public-key, jwt-signing-secret"
  value       = module.secrets.secret_arns
}

output "database_url_secret_arn" {
  description = "ARN of the full Prisma-ready DATABASE_URL secret, for ECS task definition"
  value       = module.secrets.database_url_secret_arn
}

# --- Budget ---
output "budget_name" {
  description = "AWS Budget name for cost monitoring"
  value       = module.budget.budget_name
}

#........ECS...........
output "ecs_execution_role_arn" {
  description = "Handoff to DevOps - goes in the task definition's executionRoleArn field"
  value       = module.ecs.execution_role_arn
}

output "ecs_task_role_arn" {
  description = "Handoff to DevOps - goes in the task definition's taskRoleArn field"
  value       = module.ecs.task_role_arn
}

output "ecs_app_security_group_id" {
  value = module.ecs.app_security_group_id
}

output "ecs_log_group_name" {
  description = "Handoff to DevOps - goes in the task definition's awslogs-group field"
  value       = module.ecs.log_group_name
}

#.......cloudtrail.......
output "cloudtrail_bucket_name" {
  value = module.cloudtrail.bucket_name
}

# .......ECR.......
output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "github_actions_role_arn" {
  value = module.ecr.github_actions_role_arn
}

#.......ALB.......
output "alb_logs_bucket_name" {
  value = module.alb.alb_logs_bucket_name
}

output "alb_target_group_arn" {
  description = "Handsoff to DevOps - needed for ECS service definition task registering with the ALB"
  value       = module.alb.target_group_arn
}
