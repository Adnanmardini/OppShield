variable "environment" {
  description = "Environment name, e.g. dev or prod"
  type        = string
}
variable "budget_limit_usd" {
  description = "Monthly budget threshold in USD before alerts fire"
  type        = number
}
variable "alert_emails" {
  description = "Emails to notify when budget thresholds are crossed"
  type        = list(string)
}

variable "project" {
    description = "name of project"
    type        = string
  
}
