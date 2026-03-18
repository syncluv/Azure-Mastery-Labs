# Azure Mastery Labs

![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Security](https://img.shields.io/badge/Security-DC3545?style=for-the-badge&logo=shield&logoColor=white)
![Enterprise](https://img.shields.io/badge/Enterprise-Grade-success?style=for-the-badge)

## 🎯 Overview

A collection of **production-grade Azure infrastructure labs** demonstrating enterprise networking, security, and cloud architecture best practices.

## 📚 Labs

| Lab | Description | Status |
|-----|-------------|--------|
| [01 - Load Balancer HA](./01-load-balancer-ha/) | Public Load Balancer with 3 VMs, health probes, NAT rules | ✅ Complete |
| [02 - Secure Web Architecture](./02-secure-web-architecture/) | 4-layer defense: Front Door + App Gateway + Firewall + LB | ✅ Complete |
| [03 - Enterprise Migration](./03-enterprise-migration/) | On-prem to Azure migration with Azure DevOps CI/CD | 🔄 Coming Soon |

## 🏗️ Architecture Highlights

### Lab 01: High Availability Load Balancing
```
Internet → Public Load Balancer → 3x Ubuntu VMs (Nginx)
```
## 🛠️ Technologies Used

- **Compute:** Virtual Machines, Availability Sets, Ubuntu 22.04 LTS
- **Networking:** Virtual Network, Subnets, Public IP, Standard Load Balancer
- **Security:** Network Security Groups (NSG), SSH Keys
- **Load Balancing:** Health Probes, Load Balancing Rules, Inbound NAT Rules, Outbound Rules
- **Web Server:** Nginx, Cloud-init
- **Monitoring:** Log Analytics, Diagnostic Settings
- **Tools:** Azure CLI, Azure Portal

### Lab 02: Defense in Depth Security
```
Internet → Front Door (WAF) → App Gateway (WAF) → Firewall → Internal LB → VMs
```
## 🛠️ Technologies Used

- **Compute:** Virtual Machines, Availability Sets, Ubuntu 22.04 LTSNetworkingVirtual Network, Subnets, Route Tables, Internal Load Balancer
- **Security (L7 Global):** Azure Front Door Premium, Web Application Firewall (WAF)
- **Security (L7 Regional):** Application Gateway v2, WAF v2, OWASP 3.2 Rules
- **Security (L3/L4):** Azure Firewall Premium, IDPS, Threat Intelligence
- **Security (Network):** Network Security Groups, Private Endpoints
- **Web Server:** Nginx, Cloud-init
- **Monitoring:** Log Analytics, Diagnostic Settings, Azure Monitor
- **Tools:** Azure CLI, Azure Portal, KQL Queries Serial Console

![Azure VMs](https://img.shields.io/badge/Azure-VMs-0078D4?style=flat-square&logo=microsoftazure)
![Load Balancer](https://img.shields.io/badge/Azure-Load%20Balancer-0078D4?style=flat-square&logo=microsoftazure)
![Front Door](https://img.shields.io/badge/Azure-Front%20Door-0078D4?style=flat-square&logo=microsoftazure)
![App Gateway](https://img.shields.io/badge/Azure-App%20Gateway-0078D4?style=flat-square&logo=microsoftazure)
![Firewall](https://img.shields.io/badge/Azure-Firewall-DC3545?style=flat-square&logo=microsoftazure)
![WAF](https://img.shields.io/badge/Azure-WAF-FD7E14?style=flat-square&logo=microsoftazure)
![NSG](https://img.shields.io/badge/Azure-NSG-28A745?style=flat-square&logo=microsoftazure)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat-square&logo=nginx&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=flat-square&logo=ubuntu&logoColor=white)
![Log Analytics](https://img.shields.io/badge/Azure-Log%20Analytics-0078D4?style=flat-square&logo=microsoftazure)

### Lab 03: Enterprise Migration
```
On-Prem (Hyper-V) → Azure Migrate → Azure PaaS + IaaS → Azure DevOps CI/CD
```

## 🛠️ Technologies Used

- **Compute:** Virtual Machines, Availability Sets, VM Scale Sets
- **Networking:** VNets, Subnets, NSGs, Load Balancers, Application Gateway
- **Security:** Azure Firewall, WAF, Front Door, Private Endpoints
- **DevOps:** Azure DevOps, CI/CD Pipelines
- **Monitoring:** Log Analytics, Application Insights, Azure Monitor

## 💰 Cost Warning

These labs use premium Azure services. **Delete resources immediately after completing each lab!**

| Lab | Estimated Cost |
|-----|----------------|
| Lab 01 | ~$5-10/day |
| Lab 02 | ~$50-80/day |
| Lab 03 | ~$30-50/day |

## 👤 Author

**Charles Okocha** - Snr Technical Support Specialist at OpenText Cybersecurity

- GitHub: [@syncluv](https://github.com/syncluv)
- LinkedIn: [Connect with me](https://linkedin.com/in/yourprofile)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

⭐ If you find these labs helpful, please star the repository!
