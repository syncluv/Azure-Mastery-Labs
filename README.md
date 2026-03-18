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

### Lab 02: Defense in Depth Security
```
Internet → Front Door (WAF) → App Gateway (WAF) → Firewall → Internal LB → VMs
```

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
