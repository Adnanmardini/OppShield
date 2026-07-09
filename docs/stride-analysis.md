# STRIDE Analysis — OpsShield

## Reference: Security Patterns Already Implemented (Do Not Break These)

1. `requireOrgMember` middleware — IDOR defence, must be on every org-scoped route
2. Mass assignment protection — explicit field allowlists, never `req.body` passed directly to Prisma
3. Webhook HMAC-SHA512 verification via `crypto.timingSafeEqual` — never bypass
4. Audit log — append-only, all writes via `src/lib/audit.js` only
5. JWT secrets — env vars / Secrets Manager only, app throws at startup if missing

---

## API Reference

| Method | Route | Auth | Description |
|--------|-------|------|-------------|
| POST | `/api/auth/register` | None | Register and create org |
| POST | `/api/auth/login` | None | Login |
| POST | `/api/auth/refresh` | None | Rotate refresh token |
| POST | `/api/auth/logout` | Bearer | Logout |
| POST | `/api/auth/forgot-password` | None | Request password reset |
| POST | `/api/auth/reset-password` | None | Reset with token |
| GET | `/api/auth/me` | Bearer | Current user + orgs |
| GET | `/api/organisations/:orgId` | Bearer + Member | Org details |
| PATCH | `/api/organisations/:orgId` | Bearer + Admin | Update org |
| GET | `/api/organisations/:orgId/audit-log` | Bearer + Admin | Audit log |
| GET | `/api/organisations/:orgId/audit-log/verify` | Bearer + Admin | Verify hash chain |
| GET | `/api/tasks/org/:orgId` | Bearer + Member | List tasks |
| POST | `/api/tasks/org/:orgId` | Bearer + Member | Create task |
| GET | `/api/tasks/org/:orgId/:taskId` | Bearer + Member | Get task |
| PATCH | `/api/tasks/org/:orgId/:taskId` | Bearer + Member | Update task |
| DELETE | `/api/tasks/org/:orgId/:taskId` | Bearer + Admin | Delete task |
| POST | `/api/tasks/org/:orgId/:taskId/approve` | Bearer + Admin | Approve task |
| POST | `/api/tasks/org/:orgId/:taskId/reject` | Bearer + Admin | Reject task |
| POST | `/api/members/org/:orgId/invite` | Bearer + Admin | Invite member |
| POST | `/api/members/accept-invite` | None | Accept invite |
| DELETE | `/api/members/org/:orgId/:memberId` | Bearer + Admin | Remove member |
| PATCH | `/api/members/org/:orgId/:memberId/role` | Bearer + Admin | Change role |
| GET | `/api/billing/org/:orgId` | Bearer + Member | Billing history |
| POST | `/api/billing/org/:orgId/initiate` | Bearer + Admin | Start Paystack payment |
| POST | `/api/webhooks/paystack` | Paystack HMAC | Payment webhook |
| GET | `/health` | None | Health check |

---

## Code Review Observations

### File: `src/middleware/auth.js`

**`authenticate()`**

Observations:
- The middleware reads the JWT from the `Authorization` header and requires the `Bearer <token>` format.
- Requests without a valid `Authorization` header are rejected with 401 Unauthorized.
- Token validation is delegated to `verifyAccess()` in `src/lib/jwt.js`.
- After successful token verification, the middleware queries the database using `prisma.user.findUnique()` instead of trusting the JWT payload alone.
- If the authenticated user no longer exists in the database, access is denied with 401 Unauthorized.
- All authentication failures return the same generic error message ("Invalid or expired token"), preventing information disclosure about why authentication failed.

Security Observation:
- Looking up the user on every request ensures deleted or disabled users cannot continue accessing the application with previously issued JWTs.

**`requireOrgMember()`**

Observations:
- The middleware retrieves the organisation ID from `req.params.orgId` or `req.body.organisationId`, prioritizing the URL parameter.
- Requests without an organisation ID return 400 Bad Request.
- Membership is verified using the compound key `userId_organisationId`.
- Users who are not members of the requested organisation receive 403 Forbidden before any organisation data is accessed.
- The authenticated member information and organisation details are attached to `req.member` and `req.organisation` for downstream middleware and route handlers.

Security Observation:
- This middleware provides the application's primary defence against Insecure Direct Object Reference (IDOR) attacks by ensuring users can only access organisations they belong to.

**`requireAdmin()`**

Observations:
- Administrator access is determined by checking `req.member.role`.
- Only users with the `ADMIN` role are authorized.
- Optional chaining (`req.member?.role`) ensures that if `req.member` is undefined, access is denied safely instead of causing an application error.

Security Observation:
- The middleware follows a fail-safe approach by denying access whenever organisation membership has not been established.

### File: `src/lib/jwt.js`

**JWT Secret Management**

Observations:
- Access and refresh token secrets are loaded from environment variables.
- The application throws an exception during startup if either secret is missing.
- No JWT secrets are hardcoded within the application.

Security Observation:
- Storing secrets outside the source code reduces the risk of credential exposure and supports secure secret management practices.

**Token Generation**

Observations:
- Access tokens are generated with a lifetime of 15 minutes.
- Refresh tokens are generated with a lifetime of 7 days.
- Separate secrets are used for access and refresh tokens.

Security Observation:
- Using separate secrets prevents refresh tokens from being accepted as access tokens.

**Token Verification**

Observations:
- Access tokens are verified using `verifyAccess()`.
- Refresh tokens are verified using `verifyRefresh()`.
- Token validation is performed using `jwt.verify()`, which validates token integrity and expiration.
- The JWT signing algorithm is not explicitly configured in the code and therefore relies on the default algorithm provided by the `jsonwebtoken` library (HS256).

Security Observation:
- Separating verification for access and refresh tokens improves authentication security by ensuring each token type is validated independently.

**Items Requiring Further Verification**

- Confirm the JWT algorithm is explicitly restricted during verification (currently relying on the library default).
- Identify where Express rate limiting is configured and verify that `/api/auth/login` has an appropriate brute-force protection threshold.
- Review route definitions to confirm all administrator routes apply middleware in the order: `authenticate` → `requireOrgMember` → `requireAdmin`.
- Confirm route handlers consistently use the verified organisation ID and do not re-read `req.body.organisationId` after authorization checks.

### File: `src/lib/audit.js`

**Hash Computation**

Observations:
- `computeHash(previousHash, action, timestamp)` produces a SHA-256 hash from the concatenation of `previousHash`, `action`, and `timestamp` only.
- The fields `resourceId`, `actorId`, `actorEmail`, `metadata`, and `ipAddress` are stored on each audit log entry but are **not** included as input to the hash.

Security Observation — Finding 1 (High):
Because the hash does not cover the full record, an actor with direct database write access could alter `resourceId`, `actorId`, `actorEmail`, `metadata`, or `ipAddress` on an existing entry without invalidating that entry's stored hash. The chain currently proves integrity of the `action` label, its position in the sequence, and its timestamp — it does **not** prove the rest of the row's contents are unaltered. This directly limits the "tamper-evident" guarantee described in the project brief to a narrower scope than the label implies.

Recommendation: Include all persisted fields (or a canonical serialization of the full entry) as input to the hash, not just `action` and `timestamp`.

Status: Requires team decision — Stage 1/2 fix or accepted risk.

**Chain Verification (`verifyChain()`)**

Observations:
- The verification loop iterates from index `1` to the end of the log array.
- For each entry `i`, it recomputes `computeHash(logs[i].previousHash, logs[i].action, logs[i].createdAt)` and compares the result to the entry's own stored `hash`.
- The loop does **not** compare `logs[i].previousHash` to `logs[i-1].hash` — i.e., it never confirms that an entry's recorded "previous hash" actually corresponds to the hash of the entry immediately before it in the retrieved sequence.
- The loop starts at index `1`, so `logs[0]` (the first entry for a given organisation) is never checked against its own hash at all.

Security Observation — Finding 2 (High):
Because chain linkage between consecutive entries is never verified, deleting a row entirely from the middle of an organisation's audit log would not be detected by `verifyChain()`. Each remaining entry's own hash still matches its own stored `previousHash`, so the function would continue to report the chain as valid even though a whole entry is missing from history. This means the current implementation detects **tampering of an existing entry's content** (recomputed hash mismatch) but does **not** detect **deletion of an entry**.

Recommendation: Add an explicit check that `logs[i].previousHash === logs[i-1].hash` for every `i >= 1`, and separately verify `logs[0]` against its own stored hash (with `previousHash` expected to be `null`).

Status: Requires team decision — Stage 1/2 fix or accepted risk.

**Failure Handling**

Observations:
- Audit write failures are caught and logged via `logger.error('Audit log write failed', { err: err.message, action })` rather than allowed to crash the request.

Security Observation:
- This is the exact log line to match against for the planned Wazuh detection rule covering audit log write failures (Rule 5 in the SIEM detection rule set) — noted here so the literal string is available when that rule is authored.

---

## Prisma Schema Security Findings

### RefreshToken Storage

Finding:
`RefreshToken.token` is stored as a plaintext UUID.

Evidence:
```
token String @unique @default(uuid())
```
The token value is stored directly in the database without hashing.

Risk:
If the database is compromised through backup exposure, SQL injection, or unauthorized database access, attackers could use stored refresh tokens directly without needing to crack them.

Recommendation:
Store only a hash of refresh tokens in the database. The raw refresh token should only exist client-side and during token creation.

Severity: Medium

Status: Requires team decision — Stage 1 fix or accepted risk.

### Invite Token Storage

Finding:
`Invite.token` is stored directly as a plaintext UUID.

Evidence:
```
token String @unique @default(uuid())
```

Risk:
A database compromise could expose active invitation tokens.

Impact:
An attacker could accept pending invitations if unused tokens are exposed.

Recommendation:
Store hashed invite tokens and compare hashes during invite acceptance.

Severity: Low/Medium

Status: Documented risk.

### Audit Log Database Permissions

Finding:
`AuditLog` is intended to be append-only, but database permissions have not been verified.

Evidence:
Schema comment: `"DB role for app user should have INSERT only on this table"`

Risk:
If the application database user has UPDATE or DELETE privileges, audit records could be modified or removed directly at the database level — independent of, and in addition to, the hash-chain gaps documented above.

Recommendation:
Verify the production database role permissions and revoke UPDATE/DELETE access on `AuditLog`.

Severity: High if not restricted.

Status: Pending Cloud team verification.

### Billing Data Minimization

Finding:
Billing records store payment references and status information only.

Evidence:
`Billing` model stores: `paystackRef`, `paystackEvent`, `amount`, `currency`, `status`, `plan`. No payment card information is stored.

Security Observation:
This follows data minimization principles. Sensitive payment information remains with Paystack rather than being stored internally.

Status: Accepted design.

---

## PART 5 — STRIDE Pass (Auth, Billing, Webhook)

### Route: `POST /api/auth/login`

| STRIDE | Applicable | Analysis | Verified against code? | Action |
|---|---|---|---|---|
| Spoofing | Yes | Brute-force credential guessing against user accounts | Partially verified — login route exists, but no login-specific rate limiter was found in `src/routes/auth.js` | Add and confirm login-specific rate limiting |
| Info disclosure | Yes | Login errors could reveal whether an email exists | Verified — `src/controllers/auth.js` returns the same message, "Invalid email or password", for both invalid email and invalid password combinations. bcrypt comparison also runs for missing users to reduce timing leaks | Keep generic authentication errors |
| DoS | Yes | Repeated login attempts may consume resources | Not fully verified — no route-level login rate limit was identified | Confirm login route is protected by rate limiting middleware |

### Route: `POST /api/auth/refresh`

| STRIDE | Applicable | Analysis | Verified? | Action |
|---|---|---|---|---|
| Tampering/Replay | Yes | Old refresh token reuse after rotation | Partially verified — refresh tokens are validated with `verifyRefresh()`, and old tokens are deleted during rotation. No explicit reuse-detection mechanism exists | Add refresh token reuse detection using token families, revoked status, or rotation tracking |
| Info disclosure | Yes | Refresh tokens stored as plaintext values in database | Confirmed via `prisma/schema.prisma` — `RefreshToken.token` stores the raw token | Store hashed refresh tokens instead of plaintext tokens |

### Route: `POST /api/billing/org/:orgId/initiate`

| STRIDE | Applicable | Analysis | Verified? | Action |
|---|---|---|---|---|
| Elevation of privilege | Yes | Billing initiation must be restricted to organisation admins | Verified — route uses `authenticate`, `requireOrgMember`, then `requireAdmin` in the correct order | Keep current authorization chain |
| Tampering | Yes | Client may attempt to manipulate plan or payment amount | Verified — controller selects payment amount from a server-side `PLANS` configuration based on validated plan input | Continue using server-controlled pricing |
| Repudiation | Low | Billing actions should produce audit records | Verified — `audit.log()` is called during billing initiation | Keep audit logging enabled; note the Finding 1/2 hash-chain limitations above still apply to these entries |

### Route: `POST /api/webhooks/paystack`

| STRIDE | Applicable | Analysis | Verified? | Action |
|---|---|---|---|---|
| Spoofing | Yes | Attackers may send fake Paystack webhook requests | Verified — HMAC-SHA512 signature verification is implemented using `crypto.createHmac()` and `crypto.timingSafeEqual()` | Keep signature verification before event processing |
| Tampering/Replay | Yes | A valid webhook may be modified or replayed later | Partially verified — payload modification is prevented by signature checks. Replay protection relies on `paystackRef @unique`; explicit idempotency handling is missing | Add explicit duplicate-event detection before processing |
| DoS | Yes | Public webhook endpoint may receive repeated requests | Not verified — no webhook-specific rate limiting was found in reviewed files | Confirm webhook rate limiting and request size controls |

---

## Remaining Verification Items

| Item | Required File(s) |
|---|---|
| Login rate limiting | Rate-limit middleware/config |
| Webhook rate limiting | App middleware/config |
| Refresh token reuse detection | Refresh token schema/controller updates |
| JWT algorithm explicit restriction | `src/lib/jwt.js` |
| Admin route middleware ordering (org update, member remove/role-change, task delete/approve/reject) | Route files not yet reviewed |
| Audit log DB role permissions (INSERT-only) | Infrastructure/Cloud team confirmation |

---

## Summary of Open High-Severity Findings

| # | Finding | Location | Severity | Status |
|---|---|---|---|---|
| 1 | Hash chain does not cover `resourceId`, `actorId`, `actorEmail`, `metadata`, `ipAddress` | `src/lib/audit.js` — `computeHash()` | High | Requires team decision |
| 2 | `verifyChain()` never checks `previousHash` linkage between entries; entry 0 never verified | `src/lib/audit.js` — `verifyChain()` | High | Requires team decision |
| 3 | Refresh tokens stored as plaintext UUID | `prisma/schema.prisma` — `RefreshToken` | Medium | Requires team decision |
| 4 | No login-specific rate limiting confirmed | `src/routes/auth.js` (pending review) | High | Open |
| 5 | AuditLog DB role permissions unverified | Infrastructure | High if not restricted | Pending Cloud verification |
| 6 | Invite tokens stored as plaintext UUID | `prisma/schema.prisma` — `Invite` | Low/Medium | Documented risk |
| 7 | Webhook idempotency/replay detection missing | `src/routes/webhooks.js` | Medium | Open |
