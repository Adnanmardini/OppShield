# Security Incident Log

This document records security incidents, security validation exercises, and their resolutions.

| Date       | Incident                                                                                                                        | Severity   | Status   | Resolution                                                                                                                      |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------- | ---------- | -------- | ------------------------------------------------------------------------------------------------------------------------------- |
| 2026-07-09 | Gitleaks validation detected a simulated Paystack secret (`sk_test_...`) in `fake-secret-test.js` during configuration testing. | Low (Test) | Resolved | Confirmed custom Gitleaks rule detected the fake secret. Removed the test file and reran the scan to verify a clean repository. |
| 2026-07-09 | STRIDE review identified refresh tokens stored in plaintext.                                                                    | High       | Open     | Recommendation documented to hash refresh tokens before storage.                                                                |
| 2026-07-09 | STRIDE review identified missing login-specific rate limiting.                                                                  | High       | Open     | Recommendation documented to implement login rate limiting to reduce brute-force attacks.                                       |
| 2026-07-09 | STRIDE review identified missing explicit webhook idempotency handling.                                                         | Medium     | Open     | Recommendation documented to check for previously processed Paystack references before processing webhook events.               |

---

## Incident Response Process

For each future security incident:

1. Record the date and time.
2. Describe the issue.
3. Assign a severity.
4. Record immediate containment actions.
5. Document the root cause.
6. Record corrective actions.
7. Mark the incident as Open, Monitoring, or Resolved.

---

## Severity Levels

* **Critical** – Active compromise or sensitive data exposure.
* **High** – Significant security weakness requiring prompt remediation.
* **Medium** – Moderate risk requiring planned remediation.
* **Low** – Minor issue or security validation exercise.
* **Informational** – Observation with no immediate security impact.
