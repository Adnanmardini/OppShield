variable "environment" {
  description = "Environment name, e.g. dev or prod"
  type        = string
}

variable "project" {
    description = "Name of project"
    type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "Availability zones to spread subnets across"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets (ALB lives here)"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private app subnets (ECS/EC2 lives here)"
  type        = list(string)
}

variable "database_subnet_cidrs" {
  description = "CIDRs for isolated database subnets (RDS lives here)"
  type        = list(string)
}

variable "flow_log_retention_days" {
  description = "How long to keep VPC Flow Logs in CloudWatch"
  type        = number
  default     = 30
}