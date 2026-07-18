variable "environment" {
  description = "Environment name, e.g. dev or prod"
  type        = string
}

variable "project" {
    description = "name of project"
    type        = string
}
variable "vpc_id" {
  description = "VPC ID the RDS instance deploys into"
  type        = string
}

variable "database_subnet_ids" {
  description = "Isolated database subnet IDs from the VPC module"
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "Security groups allowed to connect to the database (e.g. app/ECS SG)"
  type        = list(string)
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "16.4"
}

variable "instance_class" {
  description = "RDS instance size"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Storage in GB"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  sensitive   = true
  default     = "opsshield"
}

variable "master_username" {
  description = "Master DB username"
  type        = string
  sensitive   = true
  default     = "opsshield_admin"
}

variable "multi_az" {
  description = "Whether to deploy a standby replica in a second AZ"
  type        = bool
}

variable "backup_retention_days" {
  description = "Number of days to retain automated backups - minimum 7 per task requirement"
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_days >= 7
    error_message = "backup_retention_days must be at least 7 per project requirement."
  }
}