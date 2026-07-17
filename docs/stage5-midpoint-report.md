# Security Team — Midpoint Status Report (Stage 5)

## Detection Rules
- **Status:** Rules not yet built. Log ingestion (CloudTrail, CloudWatch) confirmed working as of Stage 4. Detection rule writing begins today (July 17).
- **Rules 1, 4, 7 (high-priority):** TBD — in progress
- **Rules 2, 3, 5, 6, 8:** TBD — queued after 1, 4, 7
- **Known constraint:** Detection engineering team working on alternative laptop without battery; progress depends on mains power availability

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
- **License risk:** Carried forward from Stage 2 — no copyleft licenses detected. Will re-verify against current SBOM.

## STRIDE Coverage
[Pending retrieval from docs/stride-analysis.md — routes reviewed, pending, rejected counts]

## Blockers / Needs From Other Teams
- [ ] Cloud: Known-good egress IP list for Rule 6
- [ ] Cloud: RDS max_connections value and CloudWatch Alarm feasibility for Rule 8
- [ ] Cloud: Confirmation on deployment/domain status for pen-test-readiness
- [ ] DevOps: Confirm app is live in staging for rule testing
- [ ] Detection Engineering: Continue rule writing (alternative laptop power constraint noted)

## Four Midpoint Questions

**1. Is the app ready for a Stage 7 pen test?**
Pending route-level security assessment; will assess based on detection rule implementation progress and STRIDE findings.

**2. Are the 3 highest-priority detection rules (1, 4, 7) genuinely proven, not just written?**
Rules not yet built. Target: proven by end of Week 2 (July 19-20). On track pending power availability for detection engineering team.

**3. Is Security's pace consistent with hitting Stage 10 by Demo Day (July 30)?**
Assessment: On track. Log ingestion confirmed. Rules writing in progress. SBOM/CVE track complete (Trivy 0 findings, Dependency-Check pending external dependency). Critical path: complete rules 1-8 and finalize detection rules status by July 22.

**4. Did any Part 0 assumptions from Stage 5 turn out wrong?**
- ✅ Confirmed: Log ingestion works (CloudTrail, CloudWatch)
- ⚠️ Finding: Rules were not built in Stage 4; detection engineering starting from scratch on rule writing
- ⚠️ Constraint: Detection team working on battery-less laptop; power availability is a real risk factor for timeline

## Next Steps
- [ ] Detection engineering: Write and test Rules 1, 4, 7 (starting today, July 17)
- [ ] Retry Dependency-Check once NVD API key is active
- [ ] Pull STRIDE coverage data and update this report
- [ ] Mid-week check-in (July 18-19) on rule progress
- [ ] Formal checkpoint meeting (July 20) with all teams

---
**Report prepared:** July 17, 2026  
**Team:** Security (SBOM/CVE + Reporting track)  
**Status:** In progress — Detection Engineering writing rules; SBOM/CVE track complete; awaiting handoff data from CloudTrail/CloudWatch confirmation
