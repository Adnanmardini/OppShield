terraform {
  backend "s3" {
    bucket         = "oppshield-tfstate"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile = true
  }
}
 