# Secrets Management

Managed by:

AWS Secrets Manager

Secrets

- DATABASE_URL
- JWT_SECRET
- JWT_REFRESH_SECRET
- PAYSTACK_SECRET_KEY
- PAYSTACK_WEBHOOK_SECRET

Access

↓

IAM Task Role

↓

Amazon ECS

↓

Application

Principles

- Never commit secrets
- Never store secrets in Docker images
- Rotate regularly
