# OWASP Dependency-Check — Status

- Attempted: july 16 2026
- Blocker: NVD API key requested and received, but NVD returning 403/404 on database update — likely key propagation delay (NVD-documented behavior, can take up to ~1 hour after issuance)
- Next step: re-run once key is confirmed active
- Command to re-run: dependency-check.sh --project "OpsShield" --scan . --format "HTML" --format "JSON" --out docs/dependency-check-report --nvdApiKey <key>
- In the meantime: Trivy CVE scan completed and cross-verified three ways (SBOM scan, filesystem scan, filesystem scan including dev dependencies) — all show 0 vulnerabilities, consistent with dependency upgrades since Stage 4 (nodemailer 6→9, uuid→14)
