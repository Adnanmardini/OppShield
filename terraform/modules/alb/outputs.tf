output "alb_dns_name" {
  value = aws_lb.main.dns_name
}
output "target_group_arn" {
  value = aws_lb_target_group.app.arn
}
output "alb_security_group_id" {
  value = aws_security_group.alb.id
}
output "alb_logs_bucket_name" {
  description = "Give to Security - this is where ALB access logs land for Wazuh"
  value       = aws_s3_bucket.alb_logs.id
}