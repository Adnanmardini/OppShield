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
