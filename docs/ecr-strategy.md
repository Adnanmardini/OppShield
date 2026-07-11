# Amazon ECR Strategy

Repository

opsshield-api

Image Lifecycle

Developer Push

↓

GitHub Actions

↓

Docker Build

↓

Trivy Scan

↓

Push to ECR

↓

Deploy ECS

Retention Policy

- Keep last 30 images
- Keep tagged releases
- Delete dangling images after 30 days
