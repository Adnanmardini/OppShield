variable "aws_region" {
  description = "AWS region for dev resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the dev VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones for dev"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "project" {
  description = "Project name used in all resource names"
  type        = string
  default     = "oppshield"
}

variable "environment" {
  description = "deployment environment (dev or prod)"
  type        = string

}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "database_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.20.0/24", "10.0.21.0/24"]
}

variable "budget_limit_usd" {
  description = "Monthly budget threshold for dev"
  type        = number
  default     = 20
}
variable "budget_alert_emails" {
  description = "Emails to notify on budget threshold breaches"
  type        = list(string)
  default     = [] # fill in via terraform.tfvars - do not hardcode real emails here
}




#variable "budget_limit_usd" {
  #description = "Monthly budget threshold for dev"
  #type        = number
 # default     = 20
#}

#variable "budget_alert_emails" {
 # description = "Emails to notify on budget threshold breaches"
 # type        = list(string)
  #default     = []
#}