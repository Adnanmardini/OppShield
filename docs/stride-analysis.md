# Stage 2 - STRIDE Security Audit (Logic Audit)

| Route | STRIDE | Analysis | Verified? | Action |
| :--- | :--- | :--- | :--- | :--- |
| **Tasks** | | | | |
| PATCH `.../:taskId` | Elevation of Privilege | Can a Member bypass approval by changing status? | **RISK** | **Logic Gap:** PATCH allowlist includes `status`. Member can bypass `/approve` route. |
| POST `.../approve` | Horizontal Privilege | Can a user from Org A approve a task in Org B? | **YES** | **Secure:** `requireOrgMember` scopes the request to the user's specific org. |
| **Members** | | | | |
| POST `.../invite` | Elevation of Privilege | Can a regular Member invite a new Admin? | **YES** | **Secure:** `requireAdmin` blocks non-admins from the invite system. |
| PATCH `.../:memberId/role` | Availability | Can an Admin demote themselves if they are the last admin? | **RISK** | **Logic Gap:** No check for "last admin" demotion. High risk of org lockout. |
| DELETE `.../:memberId` | Tampering | Can a Member delete an Admin? | **YES** | **Secure:** Route is protected by `requireAdmin`. |

## Stage 3 Security Review: Password Reset Flow

### 2. STRIDE Audit Table

| Check | Status | Notes |
| :--- | :--- | :--- |
| **Token generation (CSPRNG ≥32 bytes)** | **FAIL** | Found a TODO comment here. No actual token is being generated using crypto.randomBytes. |
| **Token stored hashed, not raw** | **FAIL** | Not implemented. The implementation is missing, so we have no proof of hashing. |
| **Expiry enforced (15-30 min)** | **FAIL** | Logic is missing. The comment mentions 1 hour, but we require a shorter window (15-30 mins). |
| **Single-use enforced** | **FAIL** | Not implemented. We need to see code that deletes the token after one successful use. |
| **Generic response (No Enumeration)** | **PASS** | I verified this part works. The API returns the same JSON message whether the email exists or not. |
| **Response timing consistent** | **NOT TESTED** | Hard to test without the full DB logic, but it's a risk if implementation stays as is. |
| **Existing sessions invalidated** | **FAIL** | No logic found to clear RefreshTokens or sessions upon a successful password change. |
| **Endpoint rate-limited** | **FAIL** | I didn't see any rate-limiting middleware applied to this specific route. |

### Sign-off Decision: SENT BACK FOR FIXES