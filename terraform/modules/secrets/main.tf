resource "aws_secretsmanager_secret" "app_secrets" {
  for_each = toset(var.secret_names)

  name        = "${var.project}/${var.environment}/${each.value}"
  description = "${var.project} ${var.environment} - ${each.value}"

  tags = {
    Environment = var.environment
  }

  # Values are NOT set here. Terraform creates the secret container only.
  # Actual values get filled in manually via console or `aws secretsmanager
  # put-secret-value` - never commit real secret values into any .tf file
  # or .tfvars, even if git-ignored.
}

# --- database-url, composed from RDS's auto-generated master secret ---
data "aws_secretsmanager_secret_version" "rds_master" {
  secret_id = var.master_user_secret_arn
}

locals {
  rds_credentials = jsondecode(data.aws_secretsmanager_secret_version.rds_master.secret_string)
  database_url    = "postgresql://${local.rds_credentials.username}:${urlencode(local.rds_credentials.password)}@${var.db_host}:${var.db_port}/${var.db_name}"
}

resource "aws_secretsmanager_secret" "database_url" {
  name        = "${var.project}/${var.environment}/database-url"
  description = "Full Prisma-compatible DATABASE_URL for ${var.project} ${var.environment}"

  tags = {
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "database_url" {
  secret_id     = aws_secretsmanager_secret.database_url.id
  secret_string = local.database_url
}