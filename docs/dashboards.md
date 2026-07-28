# Wazuh Dashboards — Stage 6

Both dashboards below are built on the `wazuh-alerts-*` index pattern and
confirmed populated with real (test-injected) alert data spanning all 8
OpsShield detection rules.

## Technical SOC Dashboard

- **Name:** OpsShield Technical SOC Dashboard
- **URL:** https://<wazuh-host-ip>/app/dashboards#/view/[dashboard-id]
- **Panels:**
  - OpsShield - Alerts Over Time by Rule (histogram, hourly buckets, split by rule.id)
  - OpsShield - All Rule Alerts (raw alert table, all 8 rule groups)
  - OpsShield - Alert Severity Breakdown (pie: Low 0-6 / Medium 7-9 / High 10-12 / Critical 13-15)
  - OpsShield - Critical Priority Rules (1,4,7) (table)
  - OpsShield - Top Source IPs (table, top 10 by data.srcip)
  - OpsShield - Alerts by MITRE Tactic (pie, rule.mitre.tactic)
- **Default time range:** Last 7 days
- **Confirmed populated with real data:** [date]
- **Screenshot:** docs/screenshots/technical-soc-dashboard.png

## Executive Dashboard

- **Name:** OpsShield Executive Dashboard
- **URL:** https://<wazuh-host-ip>/app/dashboards#/view/[dashboard-id]
- **Panels:**
  - OpsShield - Alerts This Week (metric, Last 7 days)
  - OpsShield - Alerts Previous Week (metric, custom range 8-14 days ago, for comparison)
  - OpsShield - Critical Alerts This Week (metric, filtered to rule.level >= 13)
  - OpsShield - Alert Severity Breakdown (shared pie chart, reused from Technical dashboard)
  - OpsShield - Top 3 Alert Types (pie, rule.description, top 3 by count)
  - OpsShield - Alerts by Category (pie, rule.groups)
- **Default time range:** Last 7 days
- **Design intent:** high-level only, no raw log tables — for non-technical stakeholders
- **Confirmed populated with real data:** [date]
- **Screenshot:** docs/screenshots/executive-dashboard.png

## Known Limitations

- "Top Source IPs" may show sparse/limited data since only some manually
  injected test lines (e.g. Rule 1's brute-force test) included a `srcip`
  field. This will populate more fully once real live traffic (real
  failed logins, real webhook calls, etc.) flows through the pipeline.
- All alert data behind these dashboards was generated via controlled
  manual log injection (see `docs/detection-rules-status.md`) rather than
  fully live production traffic. This is sufficient to prove rules and
  dashboards work end-to-end, but real-traffic validation is still an
  outstanding item before Stage 7.
- The temporary `<localfile>` test source in `ossec.conf` was intentionally
  left in place while building these dashboards, since removing it early
  would have interrupted test data generation. Cleanup step (Part G) to be
  done once both dashboards are finalized and screenshotted.
