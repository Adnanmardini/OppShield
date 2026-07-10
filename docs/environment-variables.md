# Environment Variables

## Authentication

JWT_SECRET

Purpose:
Signs access tokens.

Required:
Yes

Production Source:
AWS Secrets Manager

---

JWT_REFRESH_SECRET

Purpose:
Signs refresh tokens.

Production Source:
AWS Secrets Manager

---

DATABASE_URL

Purpose:
PostgreSQL connection string.

Production Source:
AWS Secrets Manager

---

PAYSTACK_SECRET_KEY

Purpose:
Payment processing.

Production Source:
AWS Secrets Manager

---

PAYSTACK_WEBHOOK_SECRET

Purpose:
Verify webhook signature.

Production Source:
AWS Secrets Manager
