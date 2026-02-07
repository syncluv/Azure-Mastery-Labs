# Troubleshooting Guide

## Common Issues and Solutions

### 1. Cannot reach the Load Balancer IP

**Symptoms:**
- Browser shows "Connection timed out" or "Cannot reach this page"
- `curl http://<IP>` hangs

**Possible Causes & Solutions:**

| Cause | Solution |
|-------|----------|
| NSG blocking port 80 | Add inbound rule: Allow TCP 80 from Any |
| Backend VMs not healthy | Check health probe status in LB Insights |
| Nginx not running | SSH to VM and run `sudo systemctl start nginx` |
| Wrong backend port | Verify LB rule uses port 80 for both frontend and backend |

### 2. All Backends Show Unhealthy

**Symptoms:**
- Health probe status is 0%
- DipAvailability metric shows failures

**Solutions:**
1. Check if `/health` endpoint exists: `curl http://<VM-IP>/health`
2. Verify NSG allows AzureLoadBalancer service tag
3. Ensure Nginx is running on all VMs
4. Check probe configuration (port 80, path /health)

### 3. SSH via NAT Rules Not Working

**Symptoms:**
- `ssh: connect to host <IP> port 50001: Connection refused`

**Solutions:**
1. Verify NAT rule exists and is associated with VM NIC
2. Check NSG allows SSH (port 22) from AzureLoadBalancer
3. Ensure VM is running
4. Verify the correct port number (50001, 50002, 50003)

### 4. Traffic Not Distributing Evenly

**Symptoms:**
- Same server responding to all requests

**Explanation:**
- This is expected behavior with 5-tuple hash
- Same source IP + port combination routes to same backend

**Solutions:**
- Use different browsers or incognito mode
- Wait for connection to timeout
- Change session persistence setting if needed

## Useful Commands

```bash
# Check VM status
az vm list -g rg-lb-lab-prod -o table

# Check health probe status
az network lb show -g rg-lb-lab-prod -n lb-web-prod \
    --query 'probes[].{Name:name,Protocol:protocol,Port:port}' -o table

# View NSG rules
az network nsg rule list -g rg-lb-lab-prod --nsg-name nsg-backend -o table

# Test connectivity from VM
az network watcher test-ip-flow --direction Inbound \
    --protocol TCP --local 10.0.1.4:80 --remote 168.63.129.16:0 \
    -g rg-lb-lab-prod --vm vm-web-1
```
