output "certificate_arn" {
  description = "Once validated, this ARN goes on the ALB's HTTPS listener"
  value       = aws_acm_certificate.main.arn
}

output "validation_record_name" {
  description = "DNS record name - hand to whoever owns DNS"
  value       = tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_name
}

output "validation_record_type" {
  value = tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_type
}

output "validation_record_value" {
  description = "DNS record value - hand to whoever owns DNS"
  value       = tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_value
}