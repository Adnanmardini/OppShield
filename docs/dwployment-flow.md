# Deployment Flow

## Current Deployment Pipeline

Developer

↓

Git Push

↓

GitHub Repository

↓

GitHub Actions

↓

Install Dependencies

↓

Run Tests

↓

Semgrep Scan

↓

Gitleaks Scan

↓

Trivy Scan

↓

Docker Build

↓

Push Image to Amazon ECR

↓

Deploy to Amazon ECS

↓

Health Check

↓

Production

---

## Desired Future State

Developer

↓

Feature Branch

↓

Pull Request

↓

Code Review

↓

CI Pipeline

↓

Docker Build

↓

Container Scan

↓

Deploy to ECS

↓

Smoke Tests

↓

Slack Notification

↓

Monitoring

↓

Grafana Dashboard

↓

Alertmanager

↓

Slack Alerts

---

## Deployment Principles

- Git is the single source of truth.
- No manual deployments.
- Every deployment is reproducible.
- Every deployment is traceable.
- Every deployment is observable.
