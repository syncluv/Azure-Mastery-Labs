# Troubleshooting Guide - Azure Secure Web Architecture

This document captures all issues encountered during the lab and their solutions.

---

## Issue 1: VMs Cannot Download Packages (apt install fails)

### Symptom
```
E: Failed to fetch http://azure.archive.ubuntu.com/ubuntu/pool/main/n/nginx/nginx_1.24.0-2ubuntu7.6_all.deb
470 status code 470
E: Unable to fetch some archives, maybe run apt-get update or try with --fix-missing?
```

### Root Cause
Route Table sends all outbound traffic (0.0.0.0/0) through Azure Firewall, but Firewall doesn't have rules to allow Ubuntu package downloads.

### Solution
**Option A: Add Firewall Application Rule**

Navigate to: `fw-policy-secure → Rule collections → AppRules → + Add rule`

| Field | Value |
|-------|-------|
| Name | `AllowUbuntuUpdates` |
| Source | `10.0.0.0/16` |
| Protocol | `Http:80, Https:443` |
| Destination type | FQDN |
| Destination | `*.ubuntu.com,*.archive.ubuntu.com` |

**Option B: Temporarily Dissociate Route Table**

Navigate to: `rt-workload → Subnets → snet-workload → Dissociate`

Install packages, then re-associate.

---

## Issue 2: Azure Firewall Requires Management Subnet

### Symptom
```
Force Tunneling requires this virtual network have a subnet named AzureFirewallManagementSubnet
```

### Root Cause
Azure Firewall Premium with Force Tunneling or Management NIC enabled requires a dedicated management subnet.

### Solution
Create additional subnet:

| Subnet Name | CIDR | Note |
|-------------|------|------|
| `AzureFirewallManagementSubnet` | `10.0.5.0/26` | Exact name required |

Also create a second public IP (`pip-firewall-mgmt`) for the Management NIC.

---

## Issue 3: Firewall Policy IDPS Grayed Out

### Symptom
IDPS settings show "Disabled" and cannot be changed.

### Root Cause
Firewall Policy was created with Standard SKU instead of Premium.

### Solution
1. Delete the Azure Firewall (must delete first due to association)
2. Delete the Firewall Policy
3. Recreate Firewall Policy with **Premium** tier
4. Recreate Azure Firewall with new Premium policy

---

## Issue 4: Application Gateway Backend Unhealthy

### Symptom
Backend health shows:
- Status: Error
- Inbound Error: DIPProbeDown
- Local Error: ResourceHealthDegraded

### Root Cause
Multiple potential causes:
1. NSG blocking traffic from App Gateway subnet
2. Wrong backend IP address
3. VMs not running Nginx
4. Route Table blocking health probes

### Solution

**Step 1: Verify NSG Rules**

Navigate to: `nsg-workload → Inbound security rules`

Required rules:
| Priority | Name | Source | Port | Action |
|----------|------|--------|------|--------|
| 100 | Allow-HTTP-From-AppGW | 10.0.0.0/24 | 80 | Allow |
| 105 | Allow-AppGW-Health | GatewayManager | 65200-65535 | Allow |
| 110 | Allow-LB-Probes | AzureLoadBalancer | 80 | Allow |

**Step 2: Verify Backend Pool IP**

Navigate to: `appgw-web → Backend pools → backend-pool`

Ensure target IP matches your Internal Load Balancer frontend IP (e.g., 10.0.1.100).

**Step 3: Verify Nginx Running on VMs**

Connect via Serial Console and run:
```bash
sudo systemctl status nginx
curl http://localhost/health
```

**Step 4: Temporarily Remove Route Table (for testing)**

Navigate to: `rt-workload → Subnets → Dissociate`

---

## Issue 5: Front Door Returns 504 Gateway Timeout

### Symptom
```
504
The service behind this page isn't responding to Azure Front Door.
Gateway Timeout
Error Info: OriginTimeout
```

### Root Cause
1. Origin group pointing to wrong target
2. Forwarding protocol mismatch (HTTPS vs HTTP)
3. Origin health probe failing

### Solution

**Step 1: Verify Origin Group Settings**

Navigate to: `fd-secure-web → Front Door manager → Origin groups → og-appgw → origin-appgw`

| Field | Correct Value |
|-------|---------------|
| Host name | App Gateway Public IP (e.g., 52.228.117.229) |
| Origin host header | Same as host name |
| HTTP port | 80 |
| HTTPS port | 443 |

**Step 2: Check Route Forwarding Protocol**

Navigate to: `fd-secure-web → Front Door manager → Routes → route-default`

| Field | Value |
|-------|-------|
| Origin group | `og-appgw` (NOT default-origin-group) |
| Forwarding protocol | **HTTP only** |
| Redirect | Uncheck "Redirect all traffic to HTTPS" |

**Step 3: Update Health Probe**

Navigate to: `Origin groups → og-appgw → Edit`

| Field | Value |
|-------|-------|
| Path | `/` |
| Protocol | HTTP |
| Probe method | GET |

---

## Issue 6: WAF Policy Cannot Associate with Front Door

### Symptom
When trying to associate WAF policy with Front Door endpoint:
```
Can not associate to this WAF policy
```
Endpoint appears grayed out.

### Root Cause
SKU mismatch between Front Door and WAF Policy:
- Front Door: Standard tier
- WAF Policy: Premium tier

### Solution
Ensure matching tiers. Either:

**Option A: Recreate Front Door as Premium**
1. Delete Front Door (remove security policy association first)
2. Create new Front Door with Premium tier
3. Associate Premium WAF policy

**Option B: Create Standard WAF Policy**
1. Create new WAF policy with Standard tier
2. Associate with Standard Front Door
3. Note: Fewer features available in Standard

---

## Issue 7: Cannot Delete Front Door Endpoint

### Symptom
```
Failed to delete the endpoint. Error: Resource is associated with security policy.
```

### Root Cause
Security policy (WAF) is associated with the endpoint.

### Solution
1. Navigate to: `fd-secure-web → Settings → Security policies`
2. Delete or dissociate the security policy
3. Now delete or modify the endpoint

---

## Issue 8: No Logs in Log Analytics

### Symptom
KQL queries return "No results found"

### Root Cause
1. Diagnostic settings not configured
2. Logs haven't arrived yet (takes 5-10 minutes)
3. Wrong query syntax

### Solution

**Step 1: Configure Diagnostic Settings**

For each resource (Front Door, App Gateway, Firewall):

Navigate to: `[Resource] → Monitoring → Diagnostic settings → + Add`

| Field | Value |
|-------|-------|
| Name | `diag-[resourcename]` |
| Logs | ✅ allLogs |
| Metrics | ✅ AllMetrics |
| Destination | Send to Log Analytics: law-secure-web |

**Step 2: Generate Traffic**

Visit your URLs multiple times:
- Normal traffic: `https://[frontdoor-url]/`
- Attack traffic: `https://[frontdoor-url]/?id=1' OR '1'='1`

**Step 3: Wait 5-10 Minutes**

**Step 4: Query with Basic Syntax**

```kusto
AzureDiagnostics
| take 50
```

Then explore available columns:
```kusto
AzureDiagnostics
| summarize count() by Category
```

---

## Issue 9: App Gateway Probe Path Returns Download

### Symptom
Accessing `/health` endpoint downloads a file instead of displaying content.

### Root Cause
The `/health` endpoint returns plain text "OK" without HTML content-type header, causing browser to download.

### Solution
This is actually working correctly! The file contains "OK" which means:
- Nginx is running ✅
- Health endpoint exists ✅
- Traffic flow is working ✅

For browser display, access `/` instead (shows HTML page).

---

## Issue 10: Firewall Blocking Internal Traffic

### Symptom
Traffic between subnets (e.g., App Gateway to VMs) being blocked.

### Root Cause
Route Table forces all traffic through Firewall, but Firewall lacks rules to allow internal VNet traffic.

### Solution
Add Network Rule:

Navigate to: `fw-policy-secure → Rule collections → NetworkRules → + Add rule`

| Field | Value |
|-------|-------|
| Name | `AllowVNetTraffic` |
| Source | `10.0.0.0/16` |
| Destination | `10.0.0.0/16` |
| Destination Ports | `*` |
| Protocol | Any |

---

## Quick Reference: Traffic Flow

```
Internet
    ↓
[Front Door + WAF] ← Global L7 protection
    ↓
[App Gateway + WAF] ← Regional L7 protection  
    ↓
[Azure Firewall] ← L3/L4 inspection (via Route Table)
    ↓
[Internal Load Balancer] ← Traffic distribution
    ↓
[VMs with Nginx] ← Application servers
```

---

## Debugging Commands

### On VMs (via Serial Console)
```bash
# Check Nginx status
sudo systemctl status nginx

# Test local health endpoint
curl http://localhost/health

# Check if listening on port 80
sudo netstat -tlnp | grep :80

# View Nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# Test outbound connectivity
curl -I https://www.microsoft.com
```

### Azure CLI
```bash
# Check App Gateway backend health
az network application-gateway show-backend-health \
    -g rg-secure-web-prod -n appgw-web

# Check Firewall status
az network firewall show -g rg-secure-web-prod -n fw-secure \
    --query "{Name:name, State:provisioningState}"

# List NSG rules
az network nsg rule list -g rg-secure-web-prod --nsg-name nsg-workload -o table
```

---

## Prevention Tips

1. **Start with minimal security** — Add layers incrementally
2. **Test each component** before adding the next
3. **Document IPs and subnets** — Many issues come from IP mismatches
4. **Check NSG rules first** — Most common cause of connectivity issues
5. **Use Portal diagnostics** — App Gateway has built-in connection troubleshooter
6. **Enable diagnostics early** — Logs take time to appear
7. **Know your SKU tiers** — Standard vs Premium matters!
