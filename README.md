# Azure Mastery Labs

[![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com)
[![Security](https://img.shields.io/badge/Security-DC3545?style=for-the-badge&logo=shield&logoColor=white)](#)
[![Enterprise](https://img.shields.io/badge/Enterprise-Grade-success?style=for-the-badge)](#)
[![DevOps](https://img.shields.io/badge/DevOps-0078D4?style=for-the-badge&logo=azuredevops&logoColor=white)](#)

---

## 🎯 Overview

A collection of **production-grade Azure infrastructure labs** demonstrating enterprise networking, security, cloud architecture, compliance, and DevOps best practices.

---

## 📚 Labs

| Lab | Description | Status |
|---|---|---|
| [01 - Load Balancer HA](./01-load-balancer-ha) | Public Load Balancer with 3 VMs, health probes, NAT rules | ✅ Complete |
| [02 - Secure Web Architecture](./02-secure-web-architecture) | 4-layer defense: Front Door + App Gateway + Firewall + LB | ✅ Complete |
| [03 - Enterprise Migration](./03-enterprise-migration) | On-prem to Azure migration with Azure DevOps CI/CD | ✅ Complete |
| [04 - M365 & Azure Security Engineering](./04-m365-security-engineering) | Zero Trust · Defender · Sentinel · Purview DLP · Automation | ✅ Complete |

---

## 🏗️ Architecture Highlights

### Lab 01: High Availability Load Balancing

```
Internet → Public Load Balancer → 3x Ubuntu VMs (Nginx)
```

### Lab 02: Defense in Depth Security

```
Internet → Front Door (WAF) → App Gateway (WAF) → Firewall → Internal LB → VMs
```

### Lab 03: Enterprise Migration

```
On-Prem (Hyper-V) → Azure Migrate → Azure PaaS + IaaS → Azure DevOps CI/CD
```

### Lab 04: Microsoft 365 & Azure Security Engineering

```
Entra ID (CA001–CA006) → Defender for Endpoint → Purview DLP → Sentinel (KQL)
Identity Protection → Azure Policy → PowerShell Automation → Logic App SOAR
```

---

## 🛠️ Technologies Used

**Labs 01–03**

[![Azure VMs](https://img.shields.io/badge/Azure-VMs-0078D4?style=flat-square&logo=microsoftazure)](https://azure.microsoft.com)
[![Load Balancer](https://img.shields.io/badge/Azure-Load%20Balancer-0078D4?style=flat-square&logo=microsoftazure)](https://azure.microsoft.com)
[![Front Door](https://img.shields.io/badge/Azure-Front%20Door-0078D4?style=flat-square&logo=microsoftazure)](https://azure.microsoft.com)
[![App Gateway](https://img.shields.io/badge/Azure-App%20Gateway-0078D4?style=flat-square&logo=microsoftazure)](https://azure.microsoft.com)
[![Firewall](https://img.shields.io/badge/Azure-Firewall-DC3545?style=flat-square&logo=microsoftazure)](https://azure.microsoft.com)
[![WAF](https://img.shields.io/badge/Azure-WAF-FD7E14?style=flat-square&logo=microsoftazure)](https://azure.microsoft.com)
[![NSG](https://img.shields.io/badge/Azure-NSG-28A745?style=flat-square&logo=microsoftazure)](https://azure.microsoft.com)
[![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat-square&logo=nginx&logoColor=white)](https://nginx.org)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=flat-square&logo=ubuntu&logoColor=white)](https://ubuntu.com)
[![Log Analytics](https://img.shields.io/badge/Azure-Log%20Analytics-0078D4?style=flat-square&logo=microsoftazure)](https://azure.microsoft.com)

**Lab 04**

[![Entra ID](https://img.shields.io/badge/Microsoft-Entra_ID-0078D4?style=flat-square&logo=microsoftazure)](https://entra.microsoft.com)
[![Defender](https://img.shields.io/badge/Microsoft-Defender-DC3545?style=flat-square&logo=microsoftazure)](https://security.microsoft.com)
[![Sentinel](https://img.shields.io/badge/Microsoft-Sentinel-0078D4?style=flat-square&logo=microsoftazure)](https://portal.azure.com)
[![Purview](https://img.shields.io/badge/Microsoft-Purview-0078D4?style=flat-square&logo=microsoftazure)](https://compliance.microsoft.com)
[![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=flat-square&logo=powershell&logoColor=white)](https://microsoft.com/powershell)
[![KQL](https://img.shields.io/badge/KQL-Query_Language-0078D4?style=flat-square)](https://learn.microsoft.com/kusto)

---

## 💰 Cost Warning

| Lab | Estimated cost | Notes |
|---|---|---|
| Lab 01 | ~$5–10/day | Delete VMs and Load Balancer after lab |
| Lab 02 | ~$50–80/day | Front Door + Firewall Premium are expensive |
| Lab 03 | ~$30–50/day | Delete all migration resources after lab |
| Lab 04 | **$0** | Runs entirely within M365 + Azure free tiers |

> **Always delete resources immediately after completing each lab!**

---

## 👤 Author

**Charles Okocha** — Senior Technical Support Specialist at OpenText Cybersecurity

- GitHub: [@syncluv](https://github.com/syncluv)
- LinkedIn: [Connect with me](https://linkedin.com/in/yourprofile)

---

## License

This project is licensed under the MIT License — see the [LICENSE](./LICENSE) file for details.

---

⭐ If you find these labs helpful, please star the repository!
