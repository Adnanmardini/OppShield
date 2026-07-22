variable "environment" {
  description = "Environment name, e.g. dev or prod"
  type        = string
}

variable "domain_name" {
  description = "Domain the certificate covers, e.g. app.opsshield.com"
  type        = string
}

variable "subject_alternative_names" {
  description = "alternative domain the certificate covers"
  type        = list(string)
}