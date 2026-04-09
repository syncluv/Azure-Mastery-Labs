# Azure Mastery Labs

[![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com)
[![Security](https://img.shields.io/badge/Security-DC3545?style=for-the-badge&logo=shield&logoColor=white)](https://azure.microsoft.com/services/security-center/)
[![Enterprise](https://img.shields.io/badge/Enterprise-Grade-success?style=for-the-badge)](https://azure.microsoft.com/solutions/enterprise/)
[![DevOps](https://img.shields.io/badge/DevOps-0078D7?style=for-the-badge&logo=azuredevops&logoColor=white)](https://dev.azure.com)

## 🎯 Overview

A collection of **production-grade Azure infrastructure labs** demonstrating enterprise networking, security, cloud migration, and DevOps best practices.

## 📚 Labs

| Lab | Description | Status |
|-----|-------------|--------|
| [01 - Load Balancer HA](01-load-balancer-ha) | Public Load Balancer with 3 VMs, health probes, NAT rules | ✅ Complete |
| [02 - Secure Web Architecture](02-secure-web-architecture) | 4-layer defense: Front Door + App Gateway + Firewall + LB | ✅ Complete |
| [03 - Enterprise Migration](03-enterprise-migration) | On-prem to Azure migration with Azure DevOps CI/CD | ✅ Complete |

## 🏗️ Architecture Highlights

### Lab 01: High Availability Load Balancing

```
Internet → Public Load Balancer → 3x Ubuntu VMs (Nginx)
```

**🛠️ Technologies:** Virtual Machines, Availability Sets, Standard Load Balancer, Health Probes, NAT Rules, NSGs, Cloud-init

---

### Lab 02: Defense in Depth Security

```
Internet → Front Door (WAF) → App Gateway (WAF) → Firewall → Internal LB → VMs
```

**🛠️ Technologies:** Azure Front Door Premium, Application Gateway v2, Azure Firewall Premium, WAF, IDPS, Private Endpoints

---

### Lab 03: Enterprise Migration

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           MIGRATION ARCHITECTURE                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ON-PREMISES (Hyper-V)              AZURE                                   │
│  ┌─────────────────┐               ┌─────────────────┐                     │
│  │ VM-FILE-01      │──── Wave 1 ──►│ Azure Files     │                     │
│  │ (File Server)   │               │ (companyfiles)  │                     │
│  └─────────────────┘               └─────────────────┘                     │
│                                                                             │
│  ┌─────────────────┐               ┌─────────────────┐                     │
│  │ VM-SQL-01       │──── Wave 2 ──►│ Azure SQL DB    │                     │
│  │ (SQL Server)    │               │ (corpintranet)  │                     │
│  └─────────────────┘               └─────────────────┘                     │
│                                                                             │
│  ┌─────────────────┐               ┌─────────────────┐                     │
│  │ VM-WEB-01       │──── Wave 3 ──►│ App Service     │                     │
│  │ (IIS + .NET)    │               │ (Web App)       │                     │
│  └─────────────────┘               └─────────────────┘                     │
│                                                                             │
│  ┌─────────────────┐               ┌─────────────────┐                     │
│  │ VM-API-01       │──── Wave 4 ──►│ Azure VM        │                     │
│  │ (Node.js)       │               │ (Linux + PM2)   │                     │
│  └─────────────────┘               └─────────────────┘                     │
│                                                                             │
│                      ┌─────────────────────────────────┐                   │
│                      │      Azure DevOps CI/CD         │                   │
│                      │  Repos → Build → Deploy → Live  │                   │
│                      └─────────────────────────────────┘                   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**🛠️ Technologies:**

| Category | Technologies |
|----------|-------------|
| **On-Prem** | Hyper-V, Windows Server 2019, IIS, SQL Server 2019, Ubuntu 20.04, Node.js |
| **Compute** | Azure App Service, Azure Virtual Machines (Linux) |
| **Database** | Azure SQL Database |
| **Storage** | Azure Storage Account, Azure Files |
| **Networking** | Virtual Network, Subnets, NSGs |
| **DevOps** | Azure DevOps, Azure Repos, Azure Pipelines, Self-hosted Agents |
| **Tools** | AzCopy, SSMS, Azure CLI, PM2 |

---

## 🛠️ Full Technology Stack

[![Azure VMs](https://img.shields.io/badge/Azure-VMs-0078D4?style=flat-square&logo=microsoftazure)](https://azure.microsoft.com/services/virtual-machines/)
[![Load Balancer](https://img.shields.io/badge/Azure-Load%20Balancer-0078D4?style=flat-square&logo=microsoftazure)](https://azure.microsoft.com/services/load-balancer/)
[![Front Door](https://img.shields.io/badge/Azure-Front%20Door-0078D4?style=flat-square&logo=microsoftazure)](https://azure.microsoft.com/services/frontdoor/)
[![App Gateway](https://img.shields.io/badge/Azure-App%20Gateway-0078D4?style=flat-square&logo=microsoftazure)](https://azure.microsoft.com/services/application-gateway/)
[![Firewall](https://img.shields.io/badge/Azure-Firewall-DC3545?style=flat-square&logo=microsoftazure)](https://azure.microsoft.com/services/azure-firewall/)
[![WAF](https://img.shields.io/badge/Azure-WAF-FD7E14?style=flat-square&logo=microsoftazure)](https://azure.microsoft.com/services/web-application-firewall/)
[![NSG](https://img.shields.io/badge/Azure-NSG-28A745?style=flat-square&logo=microsoftazure)](https://docs.microsoft.com/azure/virtual-network/network-security-groups-overview)
[![App Service](https://img.shields.io/badge/Azure-App%20Service-0078D4?style=flat-square&logo=microsoftazure)](https://azure.microsoft.com/services/app-service/)
[![Azure SQL](https://img.shields.io/badge/Azure-SQL%20Database-0078D4?style=flat-square&logo=microsoftazure)](https://azure.microsoft.com/services/sql-database/)
[![Azure Files](https://img.shields.io/badge/Azure-Files-0078D4?style=flat-square&logo=microsoftazure)](https://azure.microsoft.com/services/storage/files/)
[![Azure DevOps](https://img.shields.io/badge/Azure-DevOps-0078D7?style=flat-square&logo=azuredevops)](https://dev.azure.com)
[![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat-square&logo=nginx&logoColor=white)](https://nginx.org/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=flat-square&logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat-square&logo=nodedotjs&logoColor=white)](https://nodejs.org/)
[![Log Analytics](https://img.shields.io/badge/Azure-Log%20Analytics-0078D4?style=flat-square&logo=microsoftazure)](https://azure.microsoft.com/services/monitor/)

## 💰 Cost Warning

These labs use premium Azure services. **Delete resources immediately after completing each lab!**

| Lab | Estimated Cost | Key Resources |
|-----|----------------|---------------|
| Lab 01 | ~$5-10/day | 3 VMs, Load Balancer |
| Lab 02 | ~$50-80/day | Front Door, App Gateway, Firewall |
| Lab 03 | ~$16/month | App Service (Free), SQL (Basic), VM (B1s) |

> 💡 **Tip:** Use `az group delete` to remove all resources at once!

## 🚀 Quick Start

### Prerequisites

- Azure subscription ([Free trial](https://azure.microsoft.com/free/))
- Azure CLI installed
- For Lab 03: Windows with Hyper-V, Azure DevOps account

### Clone the Repository

```bash
git clone https://github.com/syncluv/Azure-Mastery-Labs.git
cd Azure-Mastery-Labs
```

### Run a Lab

Each lab has its own README with detailed instructions:

```bash
# Lab 01: Load Balancer
cd 01-load-balancer-ha
cat README.md

# Lab 02: Secure Web Architecture  
cd 02-secure-web-architecture
cat README.md

# Lab 03: Enterprise Migration
cd 03-enterprise-migration
cat README.md
```

## 📁 Repository Structure

```
Azure-Mastery-Labs/
├── README.md                          # This file
├── LICENSE
├── .gitignore
│
├── 01-load-balancer-ha/               # Lab 01
│   ├── README.md
│   ├── scripts/
│   └── diagrams/
│
├── 02-secure-web-architecture/        # Lab 02
│   ├── README.md
│   ├── lab2-final/
│   └── diagrams/
│
└── 03-enterprise-migration/           # Lab 03 (NEW!)
    ├── README.md
    ├── diagrams/
    │   └── architecture.svg
    ├── docs/
    │   ├── 01-onprem-setup.md
    │   ├── 02-azure-landing-zone.md
    │   ├── 03-file-migration.md
    │   ├── 04-sql-migration.md
    │   ├── 05-webapp-migration.md
    │   ├── 06-api-migration.md
    │   ├── 07-cicd-setup.md
    │   └── troubleshooting.md
    ├── scripts/
    │   ├── azure-cli/
    │   └── powershell/
    └── pipelines/
        ├── web-app-pipeline.yml
        └── api-pipeline.yml
```

## 📈 Skills Demonstrated

| Category | Skills |
|----------|--------|
| **Networking** | VNets, Subnets, NSGs, Load Balancers, DNS, Private Endpoints |
| **Security** | WAF, Firewall, IDPS, DDoS Protection, Zero Trust |
| **Compute** | VMs, App Service, Availability Sets, Cloud-init |
| **Storage** | Blob Storage, Azure Files, SMB Shares |
| **Database** | Azure SQL, SQL Server Migration |
| **DevOps** | CI/CD Pipelines, Git, YAML, Self-hosted Agents |
| **Migration** | AzCopy, SSMS, Lift-and-shift, Replatforming |
| **Monitoring** | Log Analytics, Azure Monitor, Diagnostics |

## 👤 Author

**Charles Okocha** - Senior Technical Support Specialist at OpenText Cybersecurity

* 🔗 GitHub: [@syncluv](https://github.com/syncluv)
* 💼 LinkedIn: [Connect with me](https://linkedin.com/in/yourprofile)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

⭐ **If you find these labs helpful, please star the repository!**

[![Star History Chart](https://api.star-history.com/svg?repos=syncluv/Azure-Mastery-Labs&type=Date)](https://star-history.com/#syncluv/Azure-Mastery-Labs&Date)
