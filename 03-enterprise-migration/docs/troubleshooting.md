# Troubleshooting Guide

Common issues encountered during Lab 03 and their solutions.

## 🔴 Hyper-V Issues

### Issue: Generation 2 VM Boot Failure

**Symptom:**
```
The boot loader failed.
No operating system was loaded.
```

**Cause:** ISO is not UEFI-compatible.

**Solution:** Use Generation 1 VMs instead:
```powershell
New-VM -Name 'VM-WEB-01' -Generation 1 ...
```

---

### Issue: VM Lost Applications After Reboot

**Symptom:** SQL Server, SSMS, or other installed apps disappeared after reboot.

**Cause:** ISO was still attached; VM booted from DVD and reinstalled Windows.

**Solution:** Remove ISO immediately after OS installation:
```powershell
Set-VMDvdDrive -VMName 'VM-SQL-01' -Path $null
```

---

## 🔴 Network Issues

### Issue: No Internet Access in VM

**Symptom:** `No Internet access` in Network Status.

**Cause:** Static IP configured for wrong network, or wrong switch type.

**Solution:** Use DHCP with External switch:
```powershell
Set-NetIPInterface -InterfaceAlias 'Ethernet' -Dhcp Enabled
Set-DnsClientServerAddress -InterfaceAlias 'Ethernet' -ResetServerAddresses
Restart-NetAdapter -Name 'Ethernet'
```

---

### Issue: VMs on Different Networks

**Symptom:** Some VMs can't reach others.

**Cause:** VMs have IPs from different subnets.

**Solution:** Ensure all VMs use DHCP from the same External switch.

---

### Issue: DNS Resolution Failing in Azure VM

**Symptom:** `Could not resolve host` errors.

**Solution:**
```bash
echo "127.0.0.1 $(hostname)" | sudo tee -a /etc/hosts
sudo systemctl restart systemd-resolved
```

---

## 🔴 Azure Migration Issues

### Issue: AzCopy Authentication Failed

**Symptom:** `403 Server failed to authenticate the request`

**Cause:** SAS token missing required permissions or malformed URL.

**Solution:**
1. Regenerate SAS with: Service ✅, Container ✅, Object ✅
2. Ensure URL has `?` before `sv=`: 
   ```
   https://storage.file.core.windows.net/companyfiles?sv=2024...
   ```
   NOT:
   ```
   https://storage.file.core.windows.net/companyfilessv=2024...
   ```

---

### Issue: AzCopy "Cannot transfer to root of service"

**Symptom:** `cannot transfer individual files/folders to the root of a service`

**Cause:** Missing file share name in URL.

**Solution:** Add `/companyfiles` before the SAS token:
```
https://storage.file.core.windows.net/companyfiles?sv=...
```

---

### Issue: SQL Server Connection Refused

**Symptom:** Cannot connect to SQL Server remotely.

**Solution:**
1. Enable TCP/IP in SQL Server Configuration Manager
2. Set TCP Port to 1433 in IPAll
3. Open firewall ports:
```powershell
New-NetFirewallRule -DisplayName 'SQL Server' -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow
New-NetFirewallRule -DisplayName 'SQL Browser' -Direction Inbound -Protocol UDP -LocalPort 1434 -Action Allow
```

---

### Issue: File Share Not Accessible

**Symptom:** Cannot browse `\\server\share`.

**Solution:**
```powershell
Enable-NetFirewallRule -DisplayGroup 'File and Printer Sharing'
Enable-NetFirewallRule -DisplayGroup 'Network Discovery'
```

---

## 🔴 Azure DevOps Issues

### Issue: Pipeline Parallelism Error

**Symptom:** `No hosted parallelism has been purchased or granted`

**Cause:** New Azure DevOps organizations need free tier approval.

**Solution:** Use self-hosted agent:
```bash
# On Azure VM
mkdir ~/azagent && cd ~/azagent
wget https://vstsagentpackage.azureedge.net/agent/4.x.x/vsts-agent-linux-x64-4.x.x.tar.gz
tar zxvf vsts-agent-linux-x64-*.tar.gz
./config.sh
sudo ./svc.sh install
sudo ./svc.sh start
```

---

### Issue: Pipeline Can't Find Self-Hosted Agent

**Symptom:** Pipeline stuck waiting for agent.

**Solution:**
1. Check agent status: `sudo ./svc.sh status`
2. Verify pool name in pipeline YAML matches Azure DevOps
3. Restart agent: `sudo ./svc.sh restart`

---

## 🔴 PM2 Issues

### Issue: Multiple PM2 Processes

**Symptom:** `pm2 status` shows multiple instances, some errored.

**Solution:**
```bash
pm2 delete all
pm2 start app.js --name "corp-api"
pm2 save
```

---

## 📋 Quick Reference Commands

### Hyper-V
```powershell
# Check VM status
Get-VM

# Remove ISO
Set-VMDvdDrive -VMName 'VM-NAME' -Path $null

# Check virtual switch
Get-VMSwitch
```

### Windows Networking
```powershell
# Check IP
ipconfig | findstr 'IPv4'

# Test port
Test-NetConnection -ComputerName <IP> -Port <PORT>

# Enable DHCP
Set-NetIPInterface -InterfaceAlias 'Ethernet' -Dhcp Enabled
```

### Linux Networking
```bash
# Check IP
ip addr show

# Test port
nc -zv <IP> <PORT>

# Test HTTP
curl http://<IP>:<PORT>
```

### PM2
```bash
pm2 status
pm2 logs corp-api
pm2 restart corp-api
pm2 delete all
```

### Azure CLI
```bash
# List resources
az resource list -g rg-lab03-migration -o table

# Delete resource group
az group delete -n rg-lab03-migration --yes --no-wait
```
