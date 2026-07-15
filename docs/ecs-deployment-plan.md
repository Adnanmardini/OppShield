# ECS Deployment Plan

Launch Type

Fargate

Desired Tasks

2

Minimum Healthy Percent

100%

Maximum Percent

200%

Deployment Strategy

Rolling Update

Health Check

GET /health

Load Balancer

Application Load Balancer

Logging

CloudWatch Logs

Task Role

IAM Role with access to:

- Secrets Manager
- CloudWatch
