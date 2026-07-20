# OWASP Dependency-Check — Status

## Troubleshooting performed (July 16-17, 2026)
1. Confirmed NVD API key is valid — direct `curl` request with the key returns HTTP 200
2. Verified no hidden characters/formatting issues in the key string
3. Purged local Dependency-Check cache and database, retried — same error
4. Tested with unauthenticated request — same 403/404 error (ruled out simple rate-limiting)
5. Checked for proxy interference — no proxy env vars set in this Codespace
6. Increased --nvdApiDelay to 6000ms — same error
7. Confirmed via curl -v that the exact NVD endpoint returns HTTP 200 for this key/environment

## Conclusion
The key, network connectivity, and NVD service are all confirmed working via curl.
The failure is isolated to Dependency-Check's internal Java HTTP client specifically —
likely a request header/TLS handshake difference between Java's client and curl that
NVD's API is rejecting. This is a known category of issue with Dependency-Check in
containerized/cloud dev environments (GitHub Codespaces).

## Decision
Not blocking Stage 5 checkpoint. Trivy remains the primary, cross-verified CVE source
(0 vulnerabilities, confirmed via 3 independent scan methods: SBOM scan, filesystem scan,
filesystem scan including dev dependencies).

## Next steps (lower priority, post-checkpoint)
- Retry from a non-Codespace environment (local machine/VM) if time allows before Demo Day
- Check Dependency-Check GitHub issues for known Codespaces-specific reports
