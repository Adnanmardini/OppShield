variable "environment" {
  description = "Environment name, e.g. dev or prod"
  type        = string
}

variable "secret_names" {
  description = "List of app secret names to create as empty placeholders (values filled in manually, never via Terraform)"
  type        = list(string)
  default = [
    "paystack-secret-key",
    "paystack-public-key",
    "jwt-signing-secret",
    "jwt-refresh-secret"
  ]
}
variable "project" {
  description = "name of project"
  type        = string
}

# ---needed for the composed database-url secret ---
variable "master_user_secret_arn" {
  description = "ARN of the RDS-managed master password secret (from the rds module's output)"
  type        = string
}

variable "db_host" {
  description = "RDS endpoint (host only, no port)"
  type        = string
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "opsshield"
}