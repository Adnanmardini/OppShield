# Team Dependencies

## DevOps Team

Responsibilities

- Docker
- GitHub Actions
- CI/CD
- Image Build
- Image Publishing
- ECS Deployment
- Deployment Verification
- Monitoring
- Observability
- Slack Notifications

---

## Cloud Team

Dependencies

- VPC
- ECS Cluster
- Amazon ECR
- RDS
- Secrets Manager
- Route53
- ACM Certificate
- Application Load Balancer
- IAM Roles

DevOps waits for:

- ECR Repository
- ECS Cluster
- ALB DNS
- RDS Endpoint
- Secrets Manager ARNs

---

## Security Team

Dependencies

Security provides:

- Threat Model
- Security Requirements
- WAF Rules
- GuardDuty
- Security Hub
- IAM Policies
- Security Reports

DevOps integrates:

- Semgrep
- Gitleaks
- Trivy
- Security Gates

---

## Backend Team

Dependencies

Backend provides:

- Dockerfile
- Environment Variables
- Health Endpoint
- API Documentation
- Database Migrations

DevOps provides:

- Deployment Platform
- CI/CD
- Logs
- Monitoring

---

## Frontend Team

Dependencies

Frontend provides:

- Production Build

DevOps provides:

- Hosting
- CDN
- Deployment
