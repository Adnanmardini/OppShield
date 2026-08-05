terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
data "aws_caller_identity" "current" {}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region


#locals
  default_tags {
    tags= {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "cyber_sentinel"
    }
  }
}


module "vpc" {
  source = "../../modules/vpc"

  environment            = var.environment
  project                = var.project
  vpc_cidr               = var.vpc_cidr
  azs                    = var.azs
  public_subnet_cidrs    = var.public_subnet_cidrs
  private_subnet_cidrs   = var.private_subnet_cidrs
  database_subnet_cidrs  = var.database_subnet_cidrs
}


module "budget" {
  source = "../../modules/budget"
  environment      = var.environment
  budget_limit_usd = var.budget_limit_usd
  alert_emails     = var.budget_alert_emails
  project          = var.project
}


module "rds" {
  source = "../../modules/rds"
  environment                = var.environment
  project                    = var.project
  vpc_id                     = module.vpc.vpc_id
  database_subnet_ids        = module.vpc.database_subnet_ids
  allowed_security_group_ids = [module.ecs.app_security_group_id]  # RDS allowed SG id from app layer now exists, this closes the gap from day 2
  multi_az                   = var.rds_multi_az
}


module "secrets" {
  source = "../../modules/secrets"
  master_user_secret_arn  = module.rds.master_user_secret_arn
  db_host                 = split(":", module.rds.db_endpoint)[0]
  environment = var.environment
  project     = var.project
}


module "ecs" {
  source = "../../modules/ecs"

  environment         = var.environment
  project             = var.project
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  cluster_name   = module.ecs.cluster_name
  service_name   = "opsshield-dev-service"
}


module "cloudtrail" {
  source = "../../modules/cloudtrail"

  environment         = var.environment
  project             = var.project
}


module "ecr" {
  source = "../../modules/ecr"
  environment    = var.environment
  project        = var.project
  github_username     = var.github_username
  github_repo    = var.github_repo
  github_branch  = var.github_branch # test deployment branch, will be updated in prod
}


module "alb" {
  source = "../../modules/alb"
  environment       = var.environment
  project           = var.project
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  acm_certificate_arn = module.acm.certificate_arn
}


module "acm" {
  source = "../../modules/acm"

  environment  = "dev"
  domain_name  = var.domain_name
  subject_alternative_names = ["*.srzoh.com.ng"]
}