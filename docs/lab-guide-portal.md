# Azure Public Load Balancer - Portal Lab Guide

A complete step-by-step guide for deploying an enterprise-grade Azure Public Load Balancer using the Azure Portal.

---

## 📋 Lab Overview

| | |
|---|---|
| **Duration** | 4-5 hours |
| **Difficulty** | Intermediate |
| **Cost** | ~$15-25 USD |

---

## 🎯 What You'll Build

- Standard SKU Public Load Balancer (Zone-Redundant)
- 3 Ubuntu VMs with Nginx in an Availability Set
- HTTP Health Probes with custom /health endpoint
- Load Balancing Rules for HTTP traffic
- Inbound NAT Rules for SSH management
- Outbound Rules for SNAT
- Azure Monitor integration with Log Analytics

---

## 📝 Resource Naming Convention

| Resource | Name |
|----------|------|
| Resource Group | `rg-lb-lab-prod` |
| Virtual Network | `vnet-lb-lab` |
| Subnet | `snet-backend` |
| NSG | `nsg-backend` |
| Availability Set | `avset-web` |
| Load Balancer | `lb-web-prod` |
| Public IP | `pip-lb-web` |
| VMs | `vm-web-1`, `vm-web-2`, `vm-web-3` |
| Log Analytics | `law-lb-lab` |

---

## Step 1: Create Resource Group

### Navigation
`Home → Resource groups → + Create`

### Configuration

| Field | Value |
|-------|-------|
| Subscription | *Select your subscription* |
| Resource group | `rg-lb-lab-prod` |
| Region | `East US 2` |

### Tags (Optional but recommended)

| Name | Value |
|------|-------|
| Environment | Lab |
| Project | LoadBalancer |
| Owner | *Your name* |

### Actions
1. Click **Review + create**
2. Click **Create**
3. Wait for "Resource group created" notification

---

## Step 2: Create Virtual Network

### Navigation
`Home → Virtual networks → + Create`

### Basics Tab

| Field | Value |
|-------|-------|
| Subscription | *Select your subscription* |
| Resource group | `rg-lb-lab-prod` |
| Name | `vnet-lb-lab` |
| Region | `East US 2` |

### IP Addresses Tab

| Field | Value |
|-------|-------|
| IPv4 address space | `10.0.0.0/16` |

**Add Subnet:**
1. Click **+ Add subnet**
2. Subnet name: `snet-backend`
3. Subnet address range: `10.0.1.0/24`
4. Click **Add**

### Actions
1. Click **Review + create**
2. Click **Create**

---

## Step 3: Create Network Security Group

### Navigation
`Home → Network security groups → + Create`

### Configuration

| Field | Value |
|-------|-------|
| Subscription | *Select your subscription* |
| Resource group | `rg-lb-lab-prod` |
| Name | `nsg-backend` |
| Region | `East US 2` |

### Actions
1. Click **Review + create**
2. Click **Create**
3. Wait for deployment to complete

### Add Inbound Security Rules

Navigate to: `nsg-backend → Settings → Inbound security rules → + Add`

#### Rule 1: Allow HTTP

| Field | Value |
|-------|-------|
| Source | Any |
| Source port ranges | * |
| Destination | Any |
| Service | HTTP |
| Action | Allow |
| Priority | 100 |
| Name | `Allow-HTTP` |

Click **Add**

#### Rule 2: Allow HTTPS

| Field | Value |
|-------|-------|
| Service | HTTPS |
| Priority | 110 |
| Name | `Allow-HTTPS` |

Click **Add**

#### Rule 3: Allow SSH from Load Balancer

| Field | Value |
|-------|-------|
| Source | Service Tag |
| Source service tag | AzureLoadBalancer |
| Destination port ranges | 22 |
| Protocol | TCP |
| Priority | 120 |
| Name | `Allow-SSH-LB` |

Click **Add**

### Associate NSG with Subnet

Navigate to: `nsg-backend → Settings → Subnets → + Associate`

| Field | Value |
|-------|-------|
| Virtual network | `vnet-lb-lab` |
| Subnet | `snet-backend` |

Click **OK**

---

## Step 4: Create Availability Set

### Navigation
`Home → Availability sets → + Create`

### Configuration

| Field | Value |
|-------|-------|
| Subscription | *Select your subscription* |
| Resource group | `rg-lb-lab-prod` |
| Name | `avset-web` |
| Region | `East US 2` |
| Fault domains | 2 |
| Update domains | 5 |
| Use managed disks | Yes (aligned) |

### Actions
1. Click **Review + create**
2. Click **Create**

---

## Step 5: Create Virtual Machines (Repeat 3 times)

### Navigation
`Home → Virtual machines → + Create → Azure virtual machine`

### Basics Tab

**Project Details:**

| Field | Value |
|-------|-------|
| Subscription | *Select your subscription* |
| Resource group | `rg-lb-lab-prod` |

**Instance Details:**

| Field | Value |
|-------|-------|
| Virtual machine name | `vm-web-1` *(then vm-web-2, vm-web-3)* |
| Region | `East US 2` |
| Availability options | Availability set |
| Availability set | `avset-web` |
| Security type | Trusted launch virtual machines |
| Image | Ubuntu Server 22.04 LTS - x64 Gen2 |
| Size | Standard_B2s |

**Administrator Account:**

| Field | Value |
|-------|-------|
| Authentication type | Password |
| Username | `azureadmin` |
| Password | *Create strong password - save it!* |

**Inbound Port Rules:**

| Field | Value |
|-------|-------|
| Public inbound ports | None |

### Disks Tab

| Field | Value |
|-------|-------|
| OS disk type | Standard SSD |
| Delete with VM | ✅ Checked |

### Networking Tab

| Field | Value |
|-------|-------|
| Virtual network | `vnet-lb-lab` |
| Subnet | `snet-backend` |
| Public IP | None |
| NIC network security group | None |
| Delete NIC when VM is deleted | ✅ Checked |

### Advanced Tab - Custom Data

Scroll down to **Custom data** and paste:

```yaml
#cloud-config
package_upgrade: true
packages:
  - nginx
  - curl
  - net-tools
write_files:
  - path: /var/www/html/index.html
    content: |
      <!DOCTYPE html>
      <html><head><title>Azure LB Lab</title></head>
      <body>
      <h1>Azure Load Balancer Lab</h1>
      <p>Server: HOSTNAME_PLACEHOLDER</p>
      <p>IP: IP_PLACEHOLDER</p>
      </body></html>
  - path: /var/www/html/health
    content: OK
runcmd:
  - sed -i "s/HOSTNAME_PLACEHOLDER/$(hostname)/g" /var/www/html/index.html
  - sed -i "s/IP_PLACEHOLDER/$(hostname -I | awk '{print $1}')/g" /var/www/html/index.html
  - systemctl enable nginx
  - systemctl restart nginx
```

### Actions
1. Click **Review + create**
2. Click **Create**
3. **Don't wait** - immediately create vm-web-2 and vm-web-3 with same settings

---

## Step 6: Create Load Balancer

### Navigation
`Home → Load balancers → + Create`

### Basics Tab

| Field | Value |
|-------|-------|
| Subscription | *Select your subscription* |
| Resource group | `rg-lb-lab-prod` |
| Name | `lb-web-prod` |
| Region | `East US 2` |
| SKU | Standard |
| Type | Public |
| Tier | Regional |

### Frontend IP Configuration Tab

Click **+ Add a frontend IP configuration**

| Field | Value |
|-------|-------|
| Name | `frontend-web` |
| IP version | IPv4 |
| IP type | IP address |
| Public IP address | Create new |

**Create Public IP:**

| Field | Value |
|-------|-------|
| Name | `pip-lb-web` |
| SKU | Standard |
| Availability zone | Zone-redundant |

Click **OK** then **Add**

### Backend Pools Tab

Click **+ Add a backend pool**

| Field | Value |
|-------|-------|
| Name | `backend-pool-web` |
| Virtual network | `vnet-lb-lab` |
| Backend Pool Configuration | NIC |

Click **Add** (we'll add VMs later)

### Inbound Rules Tab

#### Add Health Probe

Click **Add a health probe**

| Field | Value |
|-------|-------|
| Name | `probe-http` |
| Protocol | HTTP |
| Port | 80 |
| Path | `/health` |
| Interval | 5 |
| Unhealthy threshold | 2 |

Click **Add**

#### Add Load Balancing Rule

Click **Add a load balancing rule**

| Field | Value |
|-------|-------|
| Name | `rule-http` |
| IP Version | IPv4 |
| Frontend IP address | `frontend-web` |
| Backend pool | `backend-pool-web` |
| Protocol | TCP |
| Port | 80 |
| Backend port | 80 |
| Health probe | `probe-http` |
| Session persistence | None |
| Idle timeout (minutes) | 15 |
| TCP reset | Enabled |
| Floating IP | Disabled |
| Outbound SNAT | Use outbound rule |

Click **Add**

### Outbound Rules Tab

Click **Add an outbound rule**

| Field | Value |
|-------|-------|
| Name | `outbound-rule-web` |
| Frontend IP address | `frontend-web` |
| Backend pool | `backend-pool-web` |
| Protocol | All |
| Idle timeout (minutes) | 15 |
| TCP Reset | Enabled |
| Allocated outbound ports | Manually choose |
| Outbound ports | Ports per instance |
| Ports per instance | 10000 |

Click **Add**

### Actions
1. Click **Review + create**
2. Click **Create**
3. Wait for deployment (1-2 minutes)

---

## Step 7: Add VMs to Backend Pool

### Navigation
`lb-web-prod → Settings → Backend pools → backend-pool-web`

### Actions
1. Click **+ Add**
2. Under "Virtual machines", click **+ Add**
3. Check boxes for: `vm-web-1`, `vm-web-2`, `vm-web-3`
4. Click **Add**
5. Click **Save**

---

## Step 8: Create Inbound NAT Rules

### Navigation
`lb-web-prod → Settings → Inbound NAT rules → + Add`

### NAT Rule 1: vm-web-1

| Field | Value |
|-------|-------|
| Name | `nat-ssh-vm1` |
| Type | Azure virtual machine |
| Target virtual machine | `vm-web-1` |
| Frontend IP address | `frontend-web` |
| Frontend Port | 50001 |
| Backend port | 22 |
| Protocol | TCP |

Click **Add**

### NAT Rule 2: vm-web-2

| Field | Value |
|-------|-------|
| Name | `nat-ssh-vm2` |
| Target virtual machine | `vm-web-2` |
| Frontend Port | 50002 |

Click **Add**

### NAT Rule 3: vm-web-3

| Field | Value |
|-------|-------|
| Name | `nat-ssh-vm3` |
| Target virtual machine | `vm-web-3` |
| Frontend Port | 50003 |

Click **Add**

---

## Step 9: Configure Monitoring

### Create Log Analytics Workspace

Navigate to: `Home → Log Analytics workspaces → + Create`

| Field | Value |
|-------|-------|
| Subscription | *Select your subscription* |
| Resource group | `rg-lb-lab-prod` |
| Name | `law-lb-lab` |
| Region | `East US 2` |

Click **Review + Create** → **Create**

### Enable Diagnostic Settings

Navigate to: `lb-web-prod → Monitoring → Diagnostic settings → + Add diagnostic setting`

| Field | Value |
|-------|-------|
| Diagnostic setting name | `diag-lb-web` |

**Logs - Select:**
- ✅ LoadBalancerAlertEvent
- ✅ LoadBalancerProbeHealthStatus

**Metrics - Select:**
- ✅ AllMetrics

**Destination:**
- ✅ Send to Log Analytics workspace
- Workspace: `law-lb-lab`

Click **Save**

---

## Step 10: Validation and Testing

### Get Public IP

Navigate to: `lb-web-prod → Overview`

Copy the **Frontend public IP address**

### Test HTTP

Open browser and go to: `http://<YOUR-PUBLIC-IP>`

You should see "Azure Load Balancer Lab" with server name.

Refresh multiple times to see different servers responding.

### Test SSH via NAT Rules

```bash
# VM 1
ssh azureadmin@<YOUR-PUBLIC-IP> -p 50001

# VM 2
ssh azureadmin@<YOUR-PUBLIC-IP> -p 50002

# VM 3
ssh azureadmin@<YOUR-PUBLIC-IP> -p 50003
```

### Test Failover

1. SSH to vm-web-1: `ssh azureadmin@<IP> -p 50001`
2. Stop Nginx: `sudo systemctl stop nginx`
3. Wait 15 seconds
4. Refresh browser - should only see vm-web-2 and vm-web-3
5. Restart Nginx: `sudo systemctl start nginx`
6. Wait 15 seconds - vm-web-1 returns to rotation

### View Metrics

Navigate to: `lb-web-prod → Monitoring → Insights`

Check:
- Data Path Availability (should be 100%)
- Health Probe Status (should be 100%)

---

## Step 11: Cleanup

### Delete Resource Group

Navigate to: `Home → Resource groups → rg-lb-lab-prod`

1. Click **Delete resource group**
2. Type `rg-lb-lab-prod` to confirm
3. Click **Delete**

This deletes all resources and takes 5-10 minutes.

---

## 🔧 Troubleshooting

| Issue | Solution |
|-------|----------|
| Can't reach load balancer | Check NSG allows port 80 |
| All backends unhealthy | Verify Nginx is running and /health exists |
| SSH not working | Check NAT rules and NSG allows port 22 from AzureLoadBalancer |
| Same server every time | Normal with 5-tuple hash; try incognito mode |

---

## 📚 Next Steps

- Add HTTPS with SSL certificates
- Configure session persistence
- Set up Azure Monitor alerts
- Try the CLI deployment method

See [lab-guide-cli.md](lab-guide-cli.md) for the Azure CLI version.
