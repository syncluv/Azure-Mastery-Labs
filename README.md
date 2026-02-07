<<<<<<< HEAD
# Azure Public Load Balancer - Enterprise High Availability Lab

![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)

## 📋 Overview

This repository contains a complete hands-on lab for deploying a **production-grade Azure Public Load Balancer** with high availability web application architecture. The lab demonstrates enterprise best practices for load balancing, health monitoring, and secure management access.

![Architecture Diagram](diagrams/azure-lb-architecture.svg)

## 🎯 Learning Objectives

- Deploy Azure Public Load Balancer (Standard SKU)
- Configure backend pools with VMs in availability sets
- Implement HTTP health probes with custom endpoints
- Create load balancing rules for traffic distribution
- Configure inbound NAT rules for secure SSH access
- Set up outbound rules for SNAT configuration
- Enable Azure Monitor diagnostics and Log Analytics
- Troubleshoot common load balancer issues

## 🏗️ Architecture

| Component | Details |
|-----------|---------|
| **Load Balancer** | Standard SKU, Regional, Zone-Redundant |
| **Backend Pool** | 3 Ubuntu VMs with Nginx |
| **Health Probe** | HTTP on port 80, path: /health |
| **Availability** | Availability Set (2 FD, 5 UD) |
| **Monitoring** | Azure Monitor + Log Analytics |

## 📁 Repository Structure

```
azure-load-balancer-lab/
├── README.md
├── scripts/
│   ├── deploy-cli.sh          # Azure CLI deployment script
│   ├── cloud-init.yaml        # VM initialization script
│   ├── cleanup.sh             # Resource cleanup script
│   └── validate.sh            # Validation script
├── docs/
│   ├── lab-guide-portal.md    # Azure Portal step-by-step guide
│   ├── lab-guide-cli.md       # Azure CLI guide
│   └── troubleshooting.md     # Common issues and solutions
├── diagrams/
│   └── azure-lb-architecture.svg
└── terraform/                  # (Extension challenge)
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

## 🚀 Quick Start

### Prerequisites

- Azure subscription (Pay-as-you-go or Free Trial)
- Azure CLI 2.50+ installed
- SSH client

### Deploy with Azure CLI

```bash
# Clone the repository
git clone https://github.com/yourusername/azure-load-balancer-lab.git
cd azure-load-balancer-lab

# Login to Azure
az login

# Run the deployment script
chmod +x scripts/deploy-cli.sh
./scripts/deploy-cli.sh
```

### Deploy via Azure Portal

Follow the step-by-step guide: [Lab Guide - Portal Edition](docs/lab-guide-portal.md)

## 🔧 Configuration

### Environment Variables

```bash
export RESOURCE_GROUP="rg-lb-lab-prod"
export LOCATION="eastus2"
export LB_NAME="lb-web-prod"
export VNET_NAME="vnet-lb-lab"
```

### VM Access via NAT Rules

| VM | SSH Command |
|----|-------------|
| vm-web-1 | `ssh azureadmin@<PUBLIC_IP> -p 50001` |
| vm-web-2 | `ssh azureadmin@<PUBLIC_IP> -p 50002` |
| vm-web-3 | `ssh azureadmin@<PUBLIC_IP> -p 50003` |

## 📊 Monitoring

### Key Metrics

- **DipAvailability**: Backend health probe status
- **VipAvailability**: Load balancer data path availability
- **ByteCount / PacketCount**: Traffic throughput
- **SnatConnectionCount**: Outbound SNAT port usage

### KQL Queries

```kusto
// Health probe status over time
AzureMetrics
| where MetricName == "DipAvailability"
| summarize AvgHealth=avg(Average) by bin(TimeGenerated, 5m)
| render timechart
```

## 🧹 Cleanup

```bash
# Delete all resources
az group delete --name rg-lb-lab-prod --yes --no-wait
```

## 💡 Key Learnings

1. **Always use Standard SKU** - Basic SKU is deprecated and lacks SLA
2. **Enable TCP Reset** - Helps applications detect dead connections
3. **Configure outbound rules** - Required for backend VM internet access
4. **Use health probe endpoints** - Dedicated /health path for accurate monitoring
5. **Tag resources** - Essential for cost management and governance

## 📚 Resources

- [Azure Load Balancer Documentation](https://docs.microsoft.com/azure/load-balancer/)
- [Load Balancer SKU Comparison](https://docs.microsoft.com/azure/load-balancer/skus)
- [Health Probe Best Practices](https://docs.microsoft.com/azure/load-balancer/load-balancer-custom-probe-overview)

## 🏷️ Tags

`azure` `load-balancer` `high-availability` `nginx` `infrastructure` `cloud` `devops` `networking`

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Charles** - Principal Technical Support Specialist  
*OpenText Cybersecurity - ArcSight Support*

---

⭐ If you found this lab helpful, please give it a star!
=======
# Azure-Mastery-Labs
Azure Personalize Enterprise level Labs (Advanced)
>>>>>>> 266748e0ec06ed1e49a64121761558bbdc32ad60
