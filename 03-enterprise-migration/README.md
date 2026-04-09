# Lab 03: Enterprise Migration

[![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com)
[![DevOps](https://img.shields.io/badge/Azure_DevOps-0078D7?style=for-the-badge&logo=azuredevops&logoColor=white)](https://dev.azure.com)
[![Migration](https://img.shields.io/badge/Migration-28A745?style=for-the-badge&logo=azure-migrate&logoColor=white)](https://azure.microsoft.com/services/azure-migrate/)

## 🎯 Overview

A complete **enterprise migration lab** demonstrating the migration of a multi-tier on-premises application to Azure cloud services. This lab covers the entire migration lifecycle from on-premises simulation to Azure PaaS/IaaS deployment with CI/CD pipelines.

## 🏗️ Architecture

<img width="1477" height="601" alt="image" src="https://github.com/user-attachments/assets/a9009477-a4a1-49c8-95a6-c596573ac89e" />


### On-Premises Environment (Simulated with Hyper-V)

```
┌─────────────────────────────────────────────────────────────────────┐
│                    LOCAL HYPER-V HOST                               │
│                                                                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐     │
│  │   VM-WEB-01     │  │   VM-SQL-01     │  │  VM-FILE-01     │     │
│  │   IIS + .NET    │  │  SQL Server     │  │  File Server    │     │
│  │   192.168.2.41  │  │  192.168.2.42   │  │  192.168.2.43   │     │
│  └────────┬────────┘  └────────┬────────┘  └────────┬────────┘     │
│           │                    │                    │               │
│           └────────────────────┼────────────────────┘               │
│                                │                                    │
│                    ┌───────────┴───────────┐                        │
│                    │     VM-API-01         │                        │
│                    │   Node.js + Express   │                        │
│                    │     192.168.2.44      │                        │
│                    └───────────────────────┘                        │
└─────────────────────────────────────────────────────────────────────┘
```

### Azure Target Environment

```
┌─────────────────────────────────────────────────────────────────────┐
│                    AZURE (rg-lab03-migration)                       │
│                                                                     │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │              vnet-corp-prod (10.0.0.0/16)                     │  │
│  │                                                               │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐   │  │
│  │  │ snet-web    │  │ snet-data   │  │ snet-api            │   │  │
│  │  │ 10.0.1.0/24 │  │ 10.0.2.0/24 │  │ 10.0.3.0/24         │   │  │
│  │  │             │  │             │  │                     │   │  │
│  │  │ App Service │  │ Azure SQL   │  │ Azure VM (Linux)    │   │  │
│  │  │ (Web App)   │  │ Database    │  │ Node.js + PM2       │   │  │
│  │  └─────────────┘  └─────────────┘  └─────────────────────┘   │  │
│  │                                                               │  │
│  │  ┌─────────────────────────────────────────────────────────┐ │  │
│  │  │ snet-storage (10.0.4.0/24)                              │ │  │
│  │  │ Azure Storage Account + Azure Files (companyfiles)      │ │  │
│  │  └─────────────────────────────────────────────────────────┘ │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                    Azure DevOps                               │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐   │  │
│  │  │ Azure Repos │─►│   Build     │─►│   Deploy            │   │  │
│  │  │ (Git)       │  │  Pipeline   │  │   Pipeline          │   │  │
│  │  └─────────────┘  └─────────────┘  └─────────────────────┘   │  │
│  └───────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

### Migration Flow

```
ON-PREMISES                           AZURE
─────────────────────────────────────────────────────────────────────
VM-FILE-01 (SMB)      ──AzCopy──►     Azure Files
VM-SQL-01 (SQL)       ──SSMS────►     Azure SQL Database  
VM-WEB-01 (IIS)       ──DevOps──►     Azure App Service
VM-API-01 (Node.js)   ──DevOps──►     Azure VM (Linux)
```

## 📋 Migration Waves

| Wave | Source | Target | Strategy | Status |
|------|--------|--------|----------|--------|
| **Wave 0** | - | Azure Landing Zone | Build | ✅ Complete |
| **Wave 1** | VM-FILE-01 (File Server) | Azure Files | Replatform | ✅ Complete |
| **Wave 2** | VM-SQL-01 (SQL Server) | Azure SQL Database | Replatform | ✅ Complete |
| **Wave 3** | VM-WEB-01 (IIS) | Azure App Service | Replatform | ✅ Complete |
| **Wave 4** | VM-API-01 (Node.js) | Azure VM (Linux) | Rehost | ✅ Complete |
| **Wave 5** | - | Azure DevOps CI/CD | Build | ✅ Complete |

## 🛠️ Technologies Used

### On-Premises Stack
* **Hypervisor:** Hyper-V (Windows 10/11 Pro)
* **Web Server:** Windows Server 2019, IIS 10, ASP.NET 4.5
* **Database:** SQL Server 2019 Express, SSMS
* **File Server:** Windows Server 2019, SMB 3.0
* **API Server:** Ubuntu 20.04, Node.js 18, Express, PM2

### Azure Services
* **Compute:** Azure App Service, Azure Virtual Machines (Linux)
* **Database:** Azure SQL Database (Basic tier)
* **Storage:** Azure Storage Account, Azure Files
* **Networking:** Virtual Network, Subnets, NSGs
* **DevOps:** Azure DevOps, Azure Repos, Azure Pipelines
* **Security:** Service Connections, Managed Identity

### Tools
* **Migration:** AzCopy, SSMS, Azure Portal, Azure CLI
* **CI/CD:** Azure Pipelines (YAML), Self-hosted Agents
* **Monitoring:** Azure Monitor, PM2

## 📁 Project Structure

```
03-enterprise-migration/
├── README.md                    # This file
├── diagrams/
│   └── architecture.svg         # Architecture diagram
├── docs/
│   ├── 01-onprem-setup.md      # On-premises simulation guide
│   ├── 02-azure-landing-zone.md # Wave 0: Landing zone setup
│   ├── 03-file-migration.md    # Wave 1: Azure Files migration
│   ├── 04-sql-migration.md     # Wave 2: SQL Database migration
│   ├── 05-webapp-migration.md  # Wave 3: App Service migration
│   ├── 06-api-migration.md     # Wave 4: VM migration
│   ├── 07-cicd-setup.md        # Wave 5: DevOps pipelines
│   └── troubleshooting.md      # Common issues and solutions
├── scripts/
│   ├── azure-cli/
│   │   ├── 01-landing-zone.sh  # Create VNet, subnets, NSGs
│   │   ├── 02-storage.sh       # Create storage account
│   │   └── 03-sql.sh           # Create SQL Server
│   └── powershell/
│       ├── create-vms.ps1      # Create Hyper-V VMs
│       └── configure-network.ps1
└── pipelines/
    ├── web-app-pipeline.yml    # App Service deployment
    └── api-pipeline.yml        # VM deployment
```

## 🚀 Quick Start

### Prerequisites

- Windows 10/11 Pro with Hyper-V enabled
- Azure subscription
- Azure DevOps account
- Windows Server 2019 ISO
- Ubuntu 20.04 Server ISO

### Phase 1: On-Premises Simulation

```powershell
# Create Hyper-V VMs
New-VM -Name 'VM-WEB-01' -MemoryStartupBytes 4GB -Generation 1 -NewVHDPath 'C:\HyperV\VHDs\VM-WEB-01.vhdx' -NewVHDSizeBytes 60GB -SwitchName 'LabSwitch'
New-VM -Name 'VM-SQL-01' -MemoryStartupBytes 8GB -Generation 1 -NewVHDPath 'C:\HyperV\VHDs\VM-SQL-01.vhdx' -NewVHDSizeBytes 80GB -SwitchName 'LabSwitch'
New-VM -Name 'VM-FILE-01' -MemoryStartupBytes 2GB -Generation 1 -NewVHDPath 'C:\HyperV\VHDs\VM-FILE-01.vhdx' -NewVHDSizeBytes 100GB -SwitchName 'LabSwitch'
New-VM -Name 'VM-API-01' -MemoryStartupBytes 2GB -Generation 1 -NewVHDPath 'C:\HyperV\VHDs\VM-API-01.vhdx' -NewVHDSizeBytes 40GB -SwitchName 'LabSwitch'
```

### Phase 2: Azure Landing Zone

```bash
# Variables
rg="rg-lab03-migration"
location="canadacentral"
vnet="vnet-corp-prod"

# Create resource group
az group create --name $rg --location $location

# Create VNet and subnets
az network vnet create --resource-group $rg --name $vnet --address-prefix 10.0.0.0/16
az network vnet subnet create --resource-group $rg --vnet-name $vnet --name snet-web --address-prefix 10.0.1.0/24
az network vnet subnet create --resource-group $rg --vnet-name $vnet --name snet-data --address-prefix 10.0.2.0/24
az network vnet subnet create --resource-group $rg --vnet-name $vnet --name snet-api --address-prefix 10.0.3.0/24
az network vnet subnet create --resource-group $rg --vnet-name $vnet --name snet-storage --address-prefix 10.0.4.0/24
```

### Phase 3: Migration

```bash
# Wave 1: File Migration (run on VM-FILE-01)
azcopy copy "C:\Shares\CompanyDocs\*" "https://<storage>.file.core.windows.net/companyfiles?<SAS>" --recursive

# Wave 2: SQL Migration (use SSMS Generate Scripts with Schema + Data)
# Wave 3 & 4: Use Azure DevOps Pipelines for automated deployment
```

## 📊 Azure Resources Created

| Resource | Type | Purpose |
|----------|------|---------|
| rg-lab03-migration | Resource Group | Contains all resources |
| vnet-corp-prod | Virtual Network | Network isolation |
| snet-web, snet-data, snet-api, snet-storage | Subnets | Network segmentation |
| nsg-web, nsg-api, nsg-data | NSGs | Network security |
| stlab03migrateXXXX | Storage Account | File storage |
| companyfiles | File Share | Migrated documents |
| sql-lab03-migrate | SQL Server | Database server |
| corpintranet | SQL Database | Application database |
| app-lab03-web | App Service | Web application |
| asp-lab03-web | App Service Plan | Compute for web app |
| vm-api-azure | Virtual Machine | Node.js API server |

## 💰 Cost Estimate

| Resource | SKU | Estimated Cost |
|----------|-----|----------------|
| App Service | Free F1 | $0/month |
| Azure SQL | Basic (5 DTU) | ~$5/month |
| Azure VM | Standard_B1s | ~$10/month |
| Storage Account | Standard LRS | ~$1/month |
| **Total** | | **~$16/month** |

> 💡 **Tip:** Deallocate VMs when not in use to reduce costs!

## 🔧 CI/CD Pipeline

### Web App Pipeline (web-app-pipeline.yml)

```yaml
trigger:
  paths:
    include:
      - web-app/*

pool:
  name: 'self-hosted-pool'

stages:
- stage: Build
  jobs:
  - job: Build
    steps:
    - task: CopyFiles@2
      inputs:
        SourceFolder: 'web-app'
        TargetFolder: '$(Build.ArtifactStagingDirectory)'
    - task: PublishBuildArtifacts@1
      inputs:
        PathtoPublish: '$(Build.ArtifactStagingDirectory)'
        ArtifactName: 'web-app'

- stage: Deploy
  jobs:
  - deployment: Deploy
    environment: 'Production'
    strategy:
      runOnce:
        deploy:
          steps:
          - task: AzureWebApp@1
            inputs:
              azureSubscription: 'azure-lab03-connection'
              appName: 'app-lab03-web'
              package: '$(Pipeline.Workspace)/web-app'
```

### API Pipeline (api-pipeline.yml)

```yaml
trigger:
  paths:
    include:
      - api-app/*

pool:
  name: 'self-hosted-pool'

stages:
- stage: Deploy
  jobs:
  - job: Deploy
    steps:
    - script: |
        cp -r $(Build.SourcesDirectory)/api-app/* /home/azureadmin/api/
        cd /home/azureadmin/api
        npm install
        pm2 restart corp-api || pm2 start app.js --name "corp-api"
        pm2 save
      displayName: 'Deploy and restart API'
```

## 📚 Key Learnings

1. **Generation 1 vs Generation 2 VMs** - Use Gen 1 for older ISOs without UEFI support
2. **Remove ISOs after install** - Prevents accidental OS reinstallation
3. **External vs Internal switches** - External for DHCP, Internal needs NAT
4. **Self-hosted agents** - Free alternative to Microsoft-hosted agents
5. **AzCopy SAS tokens** - Need srt=sco (Service, Container, Object)

## 🐛 Common Issues

| Issue | Solution |
|-------|----------|
| Gen 2 VM boot failure | Use Generation 1 VM |
| No internet in VM | Use DHCP with External switch |
| SQL connection refused | Enable TCP/IP in SQL Config Manager |
| AzCopy auth failed | Regenerate SAS with correct permissions |
| Pipeline parallelism error | Use self-hosted agent |

## 🔗 Live Endpoints

| Service | URL |
|---------|-----|
| Web App | https://app-lab03-web.azurewebsites.net |
| API Health | http://[VM-IP]:3000/api/health |
| API Users | http://[VM-IP]:3000/api/users |

## 📖 Documentation
For Documentation you can reachout via linkedin

## 👤 Author

**Charles Okocha** - Senior Technical Support Specialist at OpenText Cybersecurity

* GitHub: [@syncluv](https://github.com/syncluv)
* LinkedIn: [Charles Okocha](https://linkedin.com/in/yourprofile)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.

---

⭐ **Part of the [Azure Mastery Labs](https://github.com/syncluv/Azure-Mastery-Labs) series**
