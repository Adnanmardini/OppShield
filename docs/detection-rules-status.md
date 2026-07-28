# OpsShield Detection Rules — Status

Verification method for all rules below: manual localfile injection into
`/var/ossec/logs/opsshield-test.log` (watched via a temporary `<localfile>`
block in `ossec.conf`), confirmed as a real indexed alert in Wazuh Discover
(not just a `wazuh-logtest` dry-run match).

| Rule # | Rule ID(s) | Description | Level | Verified? | Method | Date |
|---|---|---|---|---|---|---|
| 1 | 100010 / 100011 | Multiple failed login attempts from same source IP (brute force) | 10 / 5 | ✅ | Manual localfile injection, confirmed in Discover | 2026-07-21 |
| 2 | 100020 / 100021 | Multiple organisations probed (non-member access) from same source IP | 7 / 3 | ✅ | Manual localfile injection, confirmed in Discover | 2026-07-21 |
| 3 (escalation) | 100030 / 100031 | Repeated non-admin access attempts, escalated to Medium | 4 / 7 | ✅ | Manual localfile injection, confirmed in Discover | 2026-07-21 |
| 4 | 100040 | Paystack webhook received with invalid signature (CRITICAL) | 15 | ✅ | Manual localfile injection, confirmed in Discover | 2026-07-21 |
| 5 | 100050 | Audit log write failed — action going unrecorded (HIGH) | 10 | ✅ | Manual localfile injection, confirmed in Discover | 2026-07-21 |
| 6 | 100060 | Unexpected outbound connection from ECS | 8 | ✅ | Manual localfile injection, confirmed in Discover | 2026-07-21 |
| 7 | 100070 | IAM change (CreateRole/AttachRolePolicy/CreateUser) made outside CI/CD deploy role (CRITICAL) | 15 | ✅ | Manual localfile injection, confirmed in Discover | 2026-07-21 |
| 8 | 100080 | RDS connection count spike above threshold | 7 | ✅ | Manual localfile injection, confirmed in Discover | 2026-07-21 |

## Known Fixes Applied During Verification

- **Wrapping `<group name="opsshield">` tag** was missing a trailing comma,
  causing group names to concatenate (e.g. `opsshieldopsshield_rule5`
  instead of separate `opsshield` / `opsshield_rule5` tags). Fixed by
  changing to `<group name="opsshield,">`. This affected all 8 rules;
  alerts generated before the fix (e.g. one early 100050 alert) retain the
  malformed group tag and can be disregarded as historical/pre-fix noise.
- Wazuh manager service required an explicit `HOME=/var/ossec` systemd
  override (`systemctl edit wazuh-manager`) for the `aws-s3` wodle to
  correctly locate `/var/ossec/.aws/credentials` under the `wazuh_readonly`
  profile — without it, boto3 reported "config profile could not be found"
  even though the file existed with correct ownership/permissions.
- ALB bucket name in `ossec.conf` had a typo (`oppshield-...` instead of
  `opsshield-...`), causing silent `Unknown error / exit code 1` on that
  bucket's analysis. Corrected to match the real bucket name.

## Outstanding / Follow-Up Before Stage 7

- [ ] Re-run rule verification against **real, live traffic** (not just
  manually injected test lines) once the real app/AWS log pipelines are
  fully confirmed flowing in production-shaped conditions:
  - Rule 1: real failed login attempts against staging (`curl` loop, as in
    Stage 4 Part 4.4)
  - Rule 4: a real invalid-signature webhook call against the actual
    Paystack webhook endpoint
  - Rule 7: a real IAM action performed in the AWS console/CLI, confirmed
    via the actual CloudTrail bucket ingestion
  - Rules 2, 3, 6, 8: real equivalents once corresponding app/AWS log
    sources are live
- [ ] Remove temporary `<localfile>` block for `opsshield-test.log` from
  `ossec.conf` once dashboards are fully built and screenshotted (Part G
  cleanup — not done yet as of this writing).
