# CI Security Policy

## CI Security Gate Thresholds (Proposed by Security)

The following thresholds are proposed for automated security checks executed within the CI/CD pipeline.

| Security Tool                        | Blocking Threshold                                       | Rationale                                                                                                    |
| ------------------------------------ | -------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| Trivy (filesystem + container image) | Block on **Critical** and **High** vulnerabilities       | Prevent deployment of builds containing high-impact known vulnerabilities.                                   |
| Semgrep                              | Block on **Error** severity findings                     | Prevent deployment when static analysis identifies security issues requiring immediate remediation.          |
| Gitleaks                             | Block on **any confirmed secret** with **no exceptions** | Prevent accidental exposure of credentials, API keys, tokens, and other sensitive secrets in the repository. |

**Owner:** Security Team

**Review Policy:** Revisit these thresholds only if the CI pipeline becomes a significant operational bottleneck without introducing unacceptable security risk. Any proposed changes should be jointly reviewed by the Security and DevOps teams.
