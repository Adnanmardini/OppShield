# Architecture Notes

## High-Level Architecture

Client

↓

Application Load Balancer

↓

Express API

↓

Authentication Middleware

↓

Application Routes

↓

Prisma ORM

↓

PostgreSQL

---

## Authentication

Authentication is implemented using JWT.

Every protected request passes through:

src/middleware/auth.js

Responsibilities:

- Validate JWT
- Verify refresh token
- Authenticate user
- Attach authenticated user to request

---

## Authorization

Authorization is organization-scoped.

Middleware:

requireOrgMember

Purpose:

Prevent IDOR attacks by verifying that the authenticated user belongs to the requested organization.

---

## Audit Logging

Location:

src/lib/audit.js

Responsibilities:

- Append-only audit log
- SHA-256 hash chain
- Integrity verification

No service writes directly to the AuditLog table.

---

## Billing

Payment provider:

Paystack

Webhook verification:

HMAC SHA-512

Timing-safe comparison is used before processing webhook events.

---

## Database

ORM:

Prisma

Primary entities:

- Users
- Organisations
- Members
- Tasks
- Billing
- AuditLog
- Approvals

---

## DevOps Perspective

Application is containerized.

Cloud deployment target:

AWS ECS Fargate

Infrastructure:

Terraform

Deployment strategy:

GitHub Actions → ECR → ECS
