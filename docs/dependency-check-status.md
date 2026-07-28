# OWASP Dependency-Check — Status

## Troubleshooting performed (July 16-17, 2026)
1. Confirmed NVD API key is valid — direct curl request with the key returns HTTP 200
2. Verified no hidden characters/formatting issues in the key string
3. Purged local Dependency-Check cache and database, retried — same error
4. Tested with unauthenticated request — same 403/404 error (ruled out simple rate-limiting)
5. Checked for proxy interference — no proxy env vars set in this Codespace
6. Increased --nvdApiDelay to 6000ms — same error
7. Confirmed via curl -v that the exact NVD endpoint returns HTTP 200 for this key/environment
8. Researched issue — confirmed this is a known, currently unresolved bug in OWASP
   Dependency-Check itself, reported across multiple GitHub issues (#6834, #6330,
   #6859, #6357, #7880), affecting versions 6.5.3 through 10.0.2, across environments
   including CI/CD pipelines (Jenkins, Maven) unrelated to Codespaces

## Conclusion
The key, network connectivity, and NVD service are all confirmed working via curl.
This is not an issue with our key, network, or environment — it is a known, open bug
in Dependency-Check's internal Java HTTP client / NVD API integration that the
maintainers have not yet resolved, affecting multiple environments including CI/CD
pipelines unrelated to Codespaces.

## Decision
Not blocking Stage 5 checkpoint. Trivy remains the primary, cross-verified CVE source
(0 vulnerabilities, confirmed via 3 independent scan methods: SBOM scan, filesystem scan,
filesystem scan including dev dependencies).

## Next steps
- Monitor GitHub issue trackers for a fix release
- Retry from a non-Codespace environment (local machine/VM) if time allows before Demo Day
- Re-attempt if/when maintainers resolve the upstream bug
