# Day 1 - Cloud Team
**Team:** Cloud

## Tasks completed

### 1. Codebase read-through
Read `README.md`, `src/middleware/auth.js`, and `src/lib/audit.js` to understand
the application's auth flow and audit logging design before writing infra code.

### 2. Shared Terraform remote backend
Created via AWS Console (S3 + DynamoDB), one per environment:

Resource 	            Dev 	                 Prod
S3 bucket	            Oppshield-tfstate-dev	 Oppshield-tfstate-prod
Dynamodb lock table 	shared	                 shared
State key 	            dev/terraform.tfstate	 prod/terraform.tfstate


Versioning, AES256 encryption, and full public access blocking enabled on both buckets.
`backend.tf` in each environment folder (`terraform/environments/dev/`,
`terraform/environments/prod/`) points to its respective bucket.

### 3. VPC module (`terraform/modules/vpc/`)
3-tier network:
	• public subnets (ALB)
	•  private subnets (app layer)
	•  isolated database subnets (RDS)
2 AZs each, single NAT Gateway.


VPC Flow Logs enabled, writing to CloudWatch Log Group (30-day retention). This feeds
Security's Wazuh SIEM detection rule for unexpected outbound connections
from ECS.

Applied in `dev` via `terraform/environments/dev/main.tf`.

### 4. IAM permissions
Confirmed via `terraform plan` in dev - no `AccessDenied` errors on VPC,
subnet, route table, NAT gateway, EIP, flow log, or associated IAM role
creation.

## Verification
- ✅ `terraform init` succeeds in `dev` (connects to remote backend)
- ✅  `terraform plan` shows expected resources only, no errors
- ✅  `terraform apply` completed - VPC, subnets, NAT, flow logs live in dev
- ✅  Confirmed flow log group exists in CloudWatch console

## Decisions / notes for the team
- Single NAT Gateway used in dev (cost tradeoff, not per-AZ) - to be
  revisited for prod in the Well-Architected review.
- Remote state uses **separate buckets per environment** (not one shared
  bucket with different keys) so a destructive action on dev's bucket
  can never touch prod's state.

## Blockers / handoffs
- None yet. VPC outputs (`vpc_id`, `public_subnet_ids`, `private_subnet_ids`,
  `database_subnet_ids`) are ready for DevOps once they need to deploy
  into this network.