variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "github_username" {
  description = "GitHub org or username"
  type        = string
}

variable "github_repo" {
  description = "Repo name, no org prefix"
  type        = string
}

variable "github_branch" {
  description = "Branch GitHub Actions deploys from - restricts OIDC trust to this branch only"
  type        = string
}