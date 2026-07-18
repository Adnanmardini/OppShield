variable "environment" {
  description = "Environment name, e.g. dev or prod"
  type        = string
}

variable "project" {
  description = "name of project"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID from the vpc module"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs where ECS tasks run"
  type        = list(string)
}

variable "log_retention_days" {
  description = "How long to keep ECS application logs"
  type        = number
  default     = 30
}