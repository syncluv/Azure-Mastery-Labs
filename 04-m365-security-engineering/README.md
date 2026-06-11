# Lab 04 — Microsoft 365 & Azure Security Engineering

[![Microsoft 365](https://img.shields.io/badge/Microsoft_365-D83B01?style=for-the-badge&logo=microsoft&logoColor=white)](https://admin.microsoft.com)
[![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://portal.azure.com)
[![Security](https://img.shields.io/badge/Security-DC3545?style=for-the-badge&logo=shield&logoColor=white)](#)
[![Zero Trust](https://img.shields.io/badge/Zero_Trust-Architecture-success?style=for-the-badge)](#)
[![Enterprise](https://img.shields.io/badge/Enterprise-Grade-success?style=for-the-badge)](#)
[![HIPAA](https://img.shields.io/badge/HIPAA-Compliant-0078D4?style=for-the-badge)](#)
[![PCI DSS](https://img.shields.io/badge/PCI_DSS-Compliant-0078D4?style=for-the-badge)](#)

---

## 🎯 Overview

A **production-grade Microsoft 365 and Azure security engineering lab** built from scratch on a live tenant. This lab covers the full Microsoft security stack — identity, endpoint, SIEM/SOAR, data loss prevention, cloud governance, and PowerShell automation — simulating the real-world responsibilities of a cloud security engineer operating above a Managed Service Provider in a regulated enterprise environment.

**Tenant:** `TechFlux597.onmicrosoft.com`  
**Licence:** Microsoft 365 Business Premium + Entra ID P2  
**Azure:** Azure Subscription 1 — Canada Central

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                  TechFlux597.onmicrosoft.com                            │
│           Microsoft 365 Business Premium + Entra ID P2                 │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  IDENTITY LAYER — Entra ID P1 + P2 (Labs 1 & 2)                │   │
│  │  Conditional Access CA001–CA006 · Identity Protection           │   │
│  │  Named locations · Break-glass groups · What If validated       │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  ENDPOINT LAYER — Microsoft Defender for Business (Lab 3)       │   │
│  │  desktop-1mjt35n enrolled · ASR rules · T1059.001 detected      │   │
│  │  Advanced Hunting KQL · Incident investigation                  │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  DATA PROTECTION LAYER — Microsoft Purview DLP (Lab 5)          │   │
│  │  PCI DSS · HIPAA · Canada SIN · Policy tips · Simulation mode   │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  SIEM / SOAR LAYER — Microsoft Sentinel (Lab 4)                 │   │
│  │  4 data connectors · KQL analytics rules · Logic App playbook   │   │
│  │  Credential spray detection · Sign-in anomaly detection         │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  GOVERNANCE LAYER — Azure Policy + Cost Management (Lab 7)      │   │
│  │  Budget alerts · Environment tagging · Canada regions only      │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  AUTOMATION LAYER — PowerShell (Lab 8)                          │   │
│  │  Microsoft.Graph SDK · User lifecycle · Stale account reports   │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 📚 Lab Modules

| Module | Topic | Key technologies | Status |
|---|---|---|---|
| [1 — Conditional Access](#module-1--conditional-access) | Identity baseline + MFA enforcement | Entra ID P1, CA policies, Named locations | ✅ Complete |
| [2 — Identity Protection](#module-2--identity-protection) | Zero Trust + risk-based policies | Entra ID P2, Identity Protection | ✅ Complete |
| [3 — Defender for Endpoint](#module-3--microsoft-defender-for-endpoint) | Endpoint onboarding + EDR | Defender for Business, ASR, KQL | ✅ Complete |
| [4 — Microsoft Sentinel](#module-4--microsoft-sentinel) | SIEM deployment + KQL rules | Sentinel, Log Analytics, Logic Apps | ✅ Complete |
| [5 — Purview DLP](#module-5--microsoft-purview-dlp) | Data loss prevention | Purview, HIPAA, PCI DSS, SIN | ✅ Complete |
| [6 — Azure Cost Management](#module-6--azure-cost-management) | FinOps + governance | Azure Policy, Budgets, Advisor | ✅ Complete |
| [7 — PowerShell Automation](#module-7--powershell-automation) | User lifecycle automation | Microsoft.Graph SDK, Az module | ✅ Complete |

---

## 🛠️ Technologies Used

- **Identity:** Microsoft Entra ID P1 + P2, Conditional Access, Identity Protection
- **Endpoint:** Microsoft Defender for Business, Attack Surface Reduction, Advanced Hunting
- **SIEM/SOAR:** Microsoft Sentinel, Log Analytics, KQL, Azure Logic Apps
- **Compliance:** Microsoft Purview DLP, HIPAA, PCI DSS, Canada SIN
- **Governance:** Azure Policy, Azure Cost Management, Azure Advisor
- **Automation:** PowerShell, Microsoft.Graph SDK, Az module
- **Portals:** entra.microsoft.com, security.microsoft.com, purview.microsoft.com, portal.azure.com

---

## 📋 Prerequisites

| Requirement | Detail |
|---|---|
| M365 tenant | Microsoft 365 Business Premium trial |
| Azure subscription | Azure free trial ($200 credit) |
| Entra ID P2 | Add-on trial — free 30 days |
| Admin role | Global Administrator |
| PowerShell | Microsoft.Graph + Az modules |

---

## 🚀 Module 1 — Conditional Access

### What was built

**Test users and groups:**

| Account | Role | Group membership |
|---|---|---|
| `CharlesOkocha@TechFlux597.onmicrosoft.com` | Global Admin | CA-Excluded |
| `sarah.user@TechFlux597.onmicrosoft.com` | Standard user | All-Staff |
| `james.admin@TechFlux597.onmicrosoft.com` | Admin / break-glass | All-Staff + CA-Excluded |
| `syncluv@icloud.com` | B2B Guest | — |

**Named location:** `Trusted — Canada Office` (203.0.113.0/24, marked trusted)

**Conditional Access policies:**

| Policy | Condition | Action | State |
|---|---|---|---|
| CA001 — Require MFA outside trusted locations | Outside named location | Require MFA | On |
| CA002 — Block legacy authentication | Exchange ActiveSync / Other clients | Block access | On |
| CA003 — Require compliant device for SharePoint | SharePoint Online | Require compliant device | Report-only |
| CA004 — Sign-in risk MFA step-up | Sign-in risk: Medium + High | Require MFA | On |
| CA005 — User risk password change | User risk: High | Require MFA + password change | On |
| CA006 — Block high sign-in risk | Sign-in risk: High | Block access | Report-only |

**What If validation results:**

| Test | Result |
|---|---|
| Sarah from 8.8.8.8 (untrusted) | CA001 fires — MFA required ✅ |
| Sarah from 203.0.113.1 (trusted) | CA001 excluded by location ✅ |
| Any user via Exchange ActiveSync | CA002 fires — blocked ✅ |
| James (CA-Excluded) from 8.8.8.8 | CA001 does not apply ✅ |

### Key concepts
- Group-scoped policies over "All users" — prevents service account lockout
- Legacy auth blocking eliminates 99%+ of password spray attacks
- Report-only mode = validate before enforce
- Break-glass exclusion group monitored via Sentinel alerts

---

## 🚀 Module 2 — Identity Protection

### What was built

- Entra ID P2 trial activated — 25 licences assigned to all test users
- CA004: Sign-in risk Medium/High → MFA step-up (On)
- CA005: User risk High → MFA + password change (On)
- CA006: Sign-in risk High → Block access (Report-only)
- Identity Protection dashboards: Risky users, Risky sign-ins, Risk detections reviewed

### Key concepts
- **Sign-in risk** = per-event suspicion score (impossible travel, anon IP, unfamiliar properties)
- **User risk** = cumulative account compromise score (dark web credential exposure)
- Modern approach: risk policies built through CA conditions, not legacy Identity Protection sliders
- Step-up auth for medium risk vs hard block for high risk — different responses for different severity

---

## 🚀 Module 3 — Microsoft Defender for Endpoint

### What was built

**Device onboarded:** `desktop-xxxxxx` (Windows 11 25H2)  
**Method:** Local script — `WindowsDefenderATPLocalOnboardingScript.cmd`  
**Sensor health:** Active

**Detection test result:**
```
Incident #1: Execution incident on one endpoint
Severity:    Medium
Alerts:      2
  → [Test Alert] Suspicious Powershell commandline
  → Suspicious PowerShell command line
MITRE ATT&CK: T1059.001 — Command and Scripting Interpreter: PowerShell
```

**Evidence chain correlated automatically:**
```
Spaceship (user) → DESKTOP-xxxxxx (device) → 2 Processes → 127.0.0.1 (network)
```

**ASR policy:** `ASR — Lab baseline policy`

| Rule | Mode |
|---|---|
| Block Office apps from creating executable content | Audit |
| Block credential stealing from lsass.exe | Audit |
| Block executable content from email client | Audit |
| Use advanced protection against ransomware | Audit |

**Advanced Hunting KQL:**
```kusto
-- MITRE technique mapping
AlertInfo
| where Timestamp > ago(2h)
| project Timestamp, AlertId, Title, Severity, Category, AttackTechniques
| order by Timestamp desc
-- Result: ["PowerShell (T1059.001)"]
```

```kusto
-- Full evidence chain
AlertEvidence
| where Timestamp > ago(2h)
| project Timestamp, AlertId, EntityType, EvidenceRole, FileName, ProcessCommandLine
| order by Timestamp desc
```

### Key concepts
- Always stage ASR rules in audit mode before enforcing — prevents breaking legitimate workflows
- Advanced Hunting is more powerful than GUI timeline — hypothesis-driven investigation
- Defender for Business vs Plan 2 — schema differences (DeviceProcessEvents not available in Business tier)
- MSP CSOC boundary: engineer owns policy, CSOC monitors alert queue, engineer is escalation point

---

## 🚀 Module 4 — Microsoft Sentinel

### What was built

**Infrastructure:**
- Resource group: `sentinel-lab-rg` (Canada Central)
- Log Analytics workspace: `techflux-sentinel-workspace`
- Sentinel enabled — free tier (10GB/day for 31 days)

**Data connectors:**

| Connector | Data ingested | Status |
|---|---|---|
| Microsoft Defender XDR | Incidents, alerts, advanced hunting | Connected ✅ |
| Microsoft Entra ID | Sign-in logs, audit logs, user risk events | Connected ✅ |
| Entra ID Protection | Risk alerts | Connected ✅ |
| Azure Activity | Control plane operations | Connected ✅ |

**KQL Analytics Rules:**

```kusto
-- Rule 1: Sign-ins from outside Canada (Medium / Initial Access)
SigninLogs
| where TimeGenerated > ago(1d)
| where ResultType == 0
| where Location != "CA"
| project TimeGenerated, UserPrincipalName, Location, IPAddress,
          AppDisplayName, ConditionalAccessStatus
| order by TimeGenerated desc
```

```kusto
-- Rule 2: Credential spray detection (High / Credential Access / T1110.003)
let failureThreshold = 5;
let timeWindow = 20m;
SigninLogs
| where TimeGenerated > ago(1d)
| where ResultType != 0
| summarize FailureCount = count(),
            FirstFailure = min(TimeGenerated),
            LastFailure = max(TimeGenerated)
  by UserPrincipalName, IPAddress
| where FailureCount >= failureThreshold
| join kind=inner (
    SigninLogs
    | where TimeGenerated > ago(1d)
    | where ResultType == 0
    | project SuccessTime = TimeGenerated, UserPrincipalName, IPAddress
) on UserPrincipalName
| where SuccessTime > LastFailure
| where SuccessTime - LastFailure < timeWindow
| project UserPrincipalName, IPAddress, FailureCount,
          FirstFailure, LastFailure, SuccessTime
```

**SOAR — Logic App playbook:** `sentinel-high-incident-notify`
```
Trigger:  Microsoft Sentinel incident created
Condition: Severity = High
Action:   Send email (O365 Outlook) — incident title + severity + description + URL
```

### Key concepts
- Sentinel correlates signals across identity, endpoint, and cloud — single investigation surface
- KQL is the primary tool: analytics rules, workbooks, hunting, investigation all use KQL
- SOAR reduces MTTR — automated notification removes manual triage from MSP CSOC workflow
- Data connector architecture: understanding what each connector ingests and why

---

## 🚀 Module 5 — Microsoft Purview DLP

### What was built

**DLP Policies:**

| Policy | Template | Sensitive info type | Mode |
|---|---|---|---|
| DLP001 — PCI DSS | PCI Data Security Standard | Credit Card Number | Simulation |
| HIPAA | U.S. Health Insurance Act | PII Identifiers + Medical Terms | Simulation |
| DLP003 — Canada SIN | Custom | Canada Social Insurance Number | Simulation + notifications |

**Live detection test:**
```
Test email sent containing: 4532015112830366 (fake Visa test number, passes Luhn checksum)

Policy tip fired:
"You shared content that contains 1 or more credit card numbers with people outside
your organization. Consider removing the numbers or make sure it's OK that everyone
you're sharing with can view them."
```

**DLP003 custom rule:**
```
Condition: Content contains Canada Social Insurance Number (min 1 instance)
Action:    Block sharing with external users
Notify:    Policy tip — "This content appears to contain a Canadian Social Insurance Number.
            Sharing SIN numbers externally may violate privacy regulations."
Incident:  High severity — admin notification enabled
```

### Key concepts
- Cohesity = data protection at rest (backup, recovery). Purview DLP = data in motion (prevention)
- Simulation mode = run the policy against real traffic without enforcing — reveal false positives first
- Policy tips educate users at point of action — compliance through awareness not just blocking
- HIPAA template directly applicable to healthcare organisations

---

## 🚀 Module 6 — Azure Cost Management

### What was built

**Budget:** `monthly-lab-budget`
- Scope: Azure Subscription 1
- Amount: $50 CAD/month
- Alert: 80% actual cost → email notification to `CharlesOkocha@TechFlux597.onmicrosoft.com`

**Azure Policy assignments:**

| Policy | Effect | Scope |
|---|---|---|
| Require tag: Environment | Deny resource creation without tag | Azure Subscription 1 |
| Allowed locations: Canada Central + Canada East | Deny resources outside Canada | Azure Subscription 1 |

**Cost Analysis views configured:**
- Grouped by Service name
- Grouped by Resource group
- Grouped by Tag (Environment) — reveals untagged resources for remediation

### Key concepts
- **Visibility:** Cost Analysis grouped by tag — ungrouped spend is unactionable
- **Accountability:** Mandatory tagging via Azure Policy — every resource attributed to a team/project
- **Governance:** Allowed locations policy enforces data residency — critical in regulated healthcare
- **Optimisation:** Azure Advisor surfaces right-sizing and reserved instance opportunities

---

## 🚀 Module 7 — PowerShell Automation

### Setup

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser -Force
Install-Module Az -Scope CurrentUser -Force
Connect-MgGraph -Scopes "User.Read.All","Group.Read.All","Directory.Read.All"
```

### Script 1 — Tenant user enumeration

```powershell
Get-MgUser -All |
Select-Object DisplayName, UserPrincipalName, AccountEnabled |
Format-Table
```

**Output:**
```
DisplayName    UserPrincipalName                                   AccountEnabled
-----------    -----------------                                   --------------
Charles Okocha CharlesOkocha@TechFlux597.onmicrosoft.com          True
Goodness Madu  goodness.madu@TechFlux597.onmicrosoft.com          True
Neme Okon      Neme.okon@TechFlux597.onmicrosoft.com              True
Emmanuel Amadi syncluv_icloud.com#EXT#@TechFlux597.onmicrosoft.com
```

### Script 2 — Stale accounts report (90-day threshold)

```powershell
$staleDate = (Get-Date).AddDays(-90)

Get-MgUser -All -Property DisplayName,UserPrincipalName,SignInActivity,AccountEnabled |
Where-Object {
    $_.SignInActivity.LastSignInDateTime -lt $staleDate -or
    $_.SignInActivity.LastSignInDateTime -eq $null
} |
Select-Object DisplayName, UserPrincipalName, AccountEnabled,
    @{Name="LastSignIn"; Expression={$_.SignInActivity.LastSignInDateTime}} |
Export-Csv -Path "C:\Users\$env:USERNAME\StaleAccounts_$(Get-Date -Format 'yyyyMMdd').csv" -NoTypeInformation

Write-Host "Stale accounts report exported" -ForegroundColor Green
```

### Script 3 — User onboarding

```powershell
function New-TechFluxUser {
    param(
        [string]$FirstName,
        [string]$LastName,
        [string]$Department,
        [string]$JobTitle
    )

    $UPN = "$($FirstName.ToLower()).$($LastName.ToLower())@TechFlux597.onmicrosoft.com"
    $TempPassword = "TechFlux@$(Get-Random -Minimum 1000 -Maximum 9999)!"

    New-MgUser `
        -DisplayName "$FirstName $LastName" `
        -UserPrincipalName $UPN `
        -AccountEnabled `
        -PasswordProfile @{
            Password = $TempPassword
            ForceChangePasswordNextSignIn = $true
        } `
        -Department $Department `
        -JobTitle $JobTitle `
        -MailNickname "$($FirstName.ToLower()).$($LastName.ToLower())"

    Write-Host "Created: $UPN" -ForegroundColor Green
    Write-Host "Temp password: $TempPassword" -ForegroundColor Yellow
}

# Usage
New-TechFluxUser -FirstName "Test" -LastName "Employee" -Department "IT" -JobTitle "Analyst"
```

### Script 4 — User offboarding

```powershell
function Remove-TechFluxUserAccess {
    param([string]$UserUPN)

    $User = Get-MgUser -UserId $UserUPN

    # Step 1 - Disable account
    Update-MgUser -UserId $User.Id -AccountEnabled:$false
    Write-Host "Account disabled" -ForegroundColor Green

    # Step 2 - Revoke all active sessions
    Revoke-MgUserSignInSession -UserId $User.Id
    Write-Host "All sessions revoked" -ForegroundColor Green

    # Step 3 - Remove from all groups
    Get-MgUserMemberOf -UserId $User.Id | ForEach-Object {
        try {
            Remove-MgGroupMemberByRef -GroupId $_.Id -DirectoryObjectId $User.Id
            Write-Host "Removed from group: $($_.AdditionalProperties.displayName)" -ForegroundColor Green
        } catch {
            Write-Host "Could not remove from: $($_.AdditionalProperties.displayName)" -ForegroundColor Yellow
        }
    }
    Write-Host "Offboarding complete for $UserUPN" -ForegroundColor Cyan
}

# Usage
Remove-TechFluxUserAccess -UserUPN "test.employee@TechFlux597.onmicrosoft.com"
```

### Key concepts
- Microsoft.Graph SDK replaces legacy MSOnline and AzureAD modules — single unified API
- Managed Identity for scheduled automation — no stored credentials
- SignInActivity property for stale detection requires Entra ID P1/P2
- Parametrised functions make scripts reusable across environments

---

## ✅ Validation Summary

| Module | Built | Validated | Evidence |
|---|---|---|---|
| Conditional Access | 6 CA policies | What If tool — 4 scenarios passed | Policy list screenshot |
| Identity Protection | 3 risk policies | P2 licences assigned | CA overview — 10 policies |
| Defender for Endpoint | 1 device enrolled | Incident #1 fired · T1059.001 mapped | Incident graph screenshot |
| Microsoft Sentinel | 4 connectors + 2 rules | KQL queries returned results | Analytics rules screenshot |
| Purview DLP | 3 policies | Policy tip fired on live test | Notification email screenshot |
| Cost Management | Budget + 2 policies | Policies assigned at subscription scope | Azure Policy screenshot |
| PowerShell Automation | 4 scripts | Get-MgUser returned all 4 tenant users | PowerShell output screenshot |

---

## 📸 Screenshots

| File | Description |
|---|---|
| `screenshots/01-ca-policies-list.png` | All 6 CA policies (CA001–CA006) with On/Report-only states |
| `screenshots/02-what-if-test1.png` | What If — Sarah from 8.8.8.8 — CA001 fires |
| `screenshots/03-what-if-test2.png` | What If — Sarah from trusted IP — CA001 excluded |
| `screenshots/04-what-if-test3.png` | What If — Exchange ActiveSync — CA002 blocks |
| `screenshots/05-what-if-test4.png` | What If — James (break-glass) — CA001 not applied |
| `screenshots/06-defender-device-inventory.png` | desktop-1mjt35n active in Device Inventory |
| `screenshots/07-defender-incident-graph.png` | Incident #1 — evidence chain — Spaceship → processes → 127.0.0.1 |
| `screenshots/08-sentinel-analytics-rules.png` | 2 custom KQL rules — High + Medium — Custom Content |
| `screenshots/09-dlp-policies-list.png` | 3 DLP policies in simulation mode |
| `screenshots/10-dlp-policy-tip.png` | Live policy tip — "contains 1 or more credit card numbers" |
| `screenshots/11-powershell-mguser.png` | Get-MgUser output — all 4 tenant users listed |

---

## 💰 Cost

| Resource | Cost |
|---|---|
| M365 Business Premium Trial | Free (30 days) |
| Microsoft Entra ID P2 Trial | Free (30 days) |
| Azure Subscription (Sentinel workspace) | Free tier — 10GB/day for 31 days |
| Azure Policy + Cost Management | Free |
| **Total** | **$0** |

---

## 🔗 Related Labs in This Repo

| Lab | Description | Status |
|---|---|---|
| [01 - Load Balancer HA](../01-load-balancer-ha) | Public Load Balancer with 3 VMs, health probes, NAT rules | ✅ Complete |
| [02 - Secure Web Architecture](../02-secure-web-architecture) | 4-layer defense: Front Door + App Gateway + Firewall + LB | ✅ Complete |
| [03 - Enterprise Migration](../03-enterprise-migration) | On-prem to Azure migration with Azure DevOps CI/CD | ✅ Complete |
| [04 - M365 & Azure Security Engineering](../04-m365-security-engineering) | Zero Trust · Defender · Sentinel · Purview DLP · Automation | ✅ Complete |

---

## 👤 Author

**Charles Okocha** — Senior Technical Support Specialist at OpenText Cybersecurity

- GitHub: [@syncluv](https://github.com/syncluv)
- LinkedIn: [Connect with me](https://linkedin.com/in/yourprofile)
- Portfolio: Techwithcharles.ca

---

## License

This project is licensed under the MIT License — see the [LICENSE](../LICENSE) file for details.

---

⭐ If you find these labs helpful, please star the repository!
