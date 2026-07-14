output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "database_subnet_ids" {
  value = aws_subnet.database[*].id
}

output "nat_gateway_ip" {
  value = aws_eip.nat.public_ip
}

output "flow_log_group_name" {
  value = aws_cloudwatch_log_group.vpc_flow_logs.name
}