# Security Team — Midpoint Status Report (Stage 5)

## Detection Rules
- **Status:** Rules not yet built. Log ingestion (CloudTrail, CloudWatch) confirmed working as of Stage 4. Detection rule writing begins today (July 17).
- **Rules 1, 4, 7 (high-priority):** TBD — in progress
- **Rules 2, 3, 5, 6, 8:** TBD — queued after 1, 4, 7
- **Known constraint:** Detection engineering team working on alternative laptop without battery; progress depends on mains power availability

## STRIDE Coverage
- **Routes fully reviewed in Stages 1-2:** Tasks, Members
- **Routes reviewed in Stage 3:** Password Reset
- **Status breakdown:**
  - ✅ Pass: 1 (Password Reset: generic error response prevents enumeration)
  - ❌ Fail: 5 (Password Reset: token generation, hashing, expiry, single-use, session invalidation — all missing implementation)
  - ⚠️ Risk/Logic Gap: 2 (Tasks: status field in PATCH allows privilege bypass; Members: last admin can demote themselves causing org lockout)
- **Assessment:** Routes have documented security gaps. Tasks/Members gaps are known; password reset was rejected in Stage 3 and sent back for fixes. Awaiting confirmation from DevOps on password reset re-submission.

## Wazuh SIEM
- **Status:** ✅ Live and confirmed ingesting data
- **Log sources confirmed live:**
  - ✅ CloudTrail (AWS API calls)
  - ✅ CloudWatch (App logs, ALB logs via log groups)
- **Remaining sources:** RDS logs (pending confirmation)
- **Dashboard access:** Confirmed working

## SBOM/CVE
- **SBOM v1 generated:** July 16, 2026, against current main branch (510 packages)
- **Trivy scan:** 0 vulnerabilities (verified via 3 independent methods: SBOM scan, filesystem scan, filesystem+dev-deps scan)
- **Dependency-Check:** Attempted, blocked by NVD API key propagation delay. Will re-run once unblocked.
- **License risk:** No copyleft licenses detected (carried from Stage 2). Will re-verify against current SBOM.

## Blockers / Needs From Other Teams
- [ ] DevOps: Confirm password reset fixes completed and re-submitted (was rejected in Stage 3)
- [ ] Cloud: Known-good egress IP list for Rule 6
- [ ] Cloud: RDS max_connections value and CloudWatch Alarm feasibility for Rule 8
- [ ] Cloud: Confirmation on deployment/domain status for pen-test readiness
- [ ] DevOps: Confirm app is live in staging for rule testing
- [ ] Detection Engineering: Continue rule writing (alternative laptop power constraint noted)

## Four Midpoint Questions

**1. Is the app ready for a Stage 7 pen test?**
Conditional. STRIDE review shows 2 known logic gaps (Tasks status bypass, Members last-admin lockout) and password reset missing implementation. These must be fixed before pen test. Once fixes are merged, app is ready.

**2. Are the 3 highest-priority detection rules (1, 4, 7) genuinely proven, not just written?**
Rules not yet built. Target: proven by end of Week 2 (July 19-20). On track pending power availability for detection engineering team.

**3. Is Security's pace consistent with hitting Stage 10 by Demo Day (July 30)?**
Assessment: On track. Log ingestion confirmed. Rules writing in progress. SBOM/CVE track complete. STRIDE review done. Critical path: complete rules 1-8 and finalize detection rules status by July 22.

**4. Did any Part 0 assumptions from Stage 5 turn out wrong?**
- ✅ Confirmed: Log ingestion works (CloudTrail, CloudWatch)
- ⚠️ Finding: Rules were not built in Stage 4; detection engineering starting from scratch on rule writing
- ⚠️ Constraint: Detection team working on battery-less laptop; power availability is a real risk factor for timeline
- ✅ Confirmed: STRIDE gaps documented and tracked (not hidden)

## Next Steps
- [ ] Detection engineering: Write and test Rules 1, 4, 7 (starting today, July 17)
- [ ] DevOps: Re-submit fixed password reset code for Security review
- [ ] Retry Dependency-Check once NVD API key is active
- [ ] Mid-week check-in (July 18-19) on rule progress
- [ ] Formal checkpoint meeting (July 20) with all teams

---
**Report prepared:** July 17, 2026  
**Team:** Security (SBOM/CVE + Reporting track)  
**Status:** In progress — Detection Engineering writing rules; SBOM/CVE track complete; STRIDE review done; awaiting DevOps password reset re-submission
