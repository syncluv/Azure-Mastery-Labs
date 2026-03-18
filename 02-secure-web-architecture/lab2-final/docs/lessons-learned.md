# Lessons Learned - Azure Secure Web Architecture Lab

## Key Takeaways

### 1. Subnet Planning is Critical
- AzureFirewallSubnet must be exactly named
- AzureFirewallManagementSubnet required for Premium tier
- Plan CIDRs to avoid overlap

### 2. Route Tables Change Everything
- 0.0.0.0/0 → Firewall means ALL traffic goes through Firewall
- Must add Firewall rules for apt-get, health probes, etc.

### 3. NSG Rule Order Matters
- Lower priority number = processed first
- Always put Allow rules before Deny

### 4. SKU Matching is Required
- Front Door Standard = Standard WAF only
- Front Door Premium = Premium WAF only

### 5. Debugging Strategy
1. Test each layer independently
2. Start from VMs and work outward
3. Check NSG rules first
4. Temporarily remove Route Table to isolate issues

## Common Mistakes

1. ❌ HTTPS in Front Door when App Gateway only has HTTP
2. ❌ Forgetting GatewayManager service tag
3. ❌ Mismatched SKU tiers
4. ❌ Route Table without Firewall rules
