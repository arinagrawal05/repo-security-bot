# 🔒 Repo Security Bot

### Automated Security Scanner for GitHub Repositories

**Gitleaks • Bandit • Checkov • Nuclei • Dockle**
Secure your repo with a single workflow call.

---

## ⭐ Overview

**Repo Security Bot** is a plug-and-play GitHub Security Scanner that automatically runs **five industry-standard security tools** on every push, pull request, or scheduled scan.

It aggregates all results into a clean **security-summary.md** and automatically creates a **GitHub Issue** containing the complete findings.

This bot is designed for teams that want **fast and automated vulnerability insights with zero setup**.

---

## 🛡️ What It Scans

| Tool         | Detects                                                                   |
| ------------ | ------------------------------------------------------------------------- |
| **Gitleaks** | Hardcoded secrets, API keys, credentials, tokens                          |
| **Bandit**   | Python security issues: injections, unsafe subprocess, weak crypto        |
| **Checkov**  | IaC misconfigurations (Terraform, CloudFormation, Kubernetes, Serverless) |
| **Nuclei**   | Vulnerability scans using community templates (CVE, misconfig, exposures) |
| **Dockle**   | Docker image best practices, hardening issues, CIS violations             |

Each scan produces:

* `.json` raw report
* Clean `.md` summary
* All reports included in the bot’s final summary
* Automatic GitHub Issue creation

---

## 🚀 How to Use in *Your* Repository

Create a workflow file in **your project**:

**`.github/workflows/run-security-bot.yml`**

```yaml
name: "Run Security Bot"

on:
  push:
    branches: [ main ]   # change branch if needed
  pull_request:
  schedule:
    - cron: "0 12 * * *"  # OPTIONAL: run daily at 12:00 UTC
  workflow_dispatch:      # manual trigger

permissions:
  contents: read
  issues: write
  checks: write
  actions: read
  pull-requests: write

jobs:
  call-bot:
    uses: arinagrawal05/repo-security-bot/.github/workflows/repo-security-bot.yml@main
    
    secrets: inherit    # passes your repo secrets (SNYK_TOKEN, etc.)
```

### ✔️ Supports:

* Manual run
* PR run
* Automatic daily scheduled scanning
* Uses your repo’s SNYK_TOKEN / other secrets automatically

---

## 📦 What You Will Get

After the bot runs:

### 1️⃣ **Artifacts**

```
security-summary.md
gitleaks.json / gitleaks.md
snyk.json / snyk.md
checkov.json / checkov.md
nuclei.json / nuclei.md
dockle.json / dockle.md
```

### 2️⃣ **Automatic GitHub Issue**

Generated with:

* All scanner sections
* Clean markdown tables
* Severity counts
* Actionable findings
* Recommended fixes

Perfect for triage & tracking.

---

## 🧪 Example Implementation

🔗 **Example Repo Using This Bot:**
[https://github.com/arinagrawal05/very-vulnerable-repo](https://github.com/arinagrawal05/very-vulnerable-repo)

Check its **Actions tab** and **Issues tab** to see how Repo Security Bot behaves in a real vulnerable environment.

---

## ⭐ Please Star This Repo!

If this bot helps secure your projects, please **star the repo**.
It motivates further improvements & helps others discover it.

⭐ [https://github.com/arinagrawal05/repo-security-bot](https://github.com/arinagrawal05/repo-security-bot)
