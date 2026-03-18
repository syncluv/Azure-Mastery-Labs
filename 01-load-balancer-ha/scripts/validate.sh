#!/bin/bash
#===============================================================================
# Azure Load Balancer Lab - Validation Script
#===============================================================================

RESOURCE_GROUP="rg-lb-lab-prod"
LB_NAME="lb-web-prod"
PIP_NAME="pip-lb-web"

echo "=== Azure Load Balancer Lab Validation ==="
echo ""

echo "1. Load Balancer Status:"
az network lb show -g $RESOURCE_GROUP -n $LB_NAME \
    --query '{Name:name,SKU:sku.name,State:provisioningState}' -o table
echo ""

echo "2. Backend Pool Members:"
az network lb address-pool show -g $RESOURCE_GROUP --lb-name $LB_NAME \
    -n backend-pool-web --query 'backendIpConfigurations[].id' -o tsv | \
    xargs -I {} basename {}
echo ""

echo "3. Health Probe Configuration:"
az network lb probe show -g $RESOURCE_GROUP --lb-name $LB_NAME \
    -n probe-http --query '{Protocol:protocol,Port:port,Path:requestPath}' -o table
echo ""

echo "4. HTTP Connectivity Test:"
PUBLIC_IP=$(az network public-ip show -g $RESOURCE_GROUP -n $PIP_NAME -q ipAddress -o tsv)
for i in 1 2 3; do
    RESPONSE=$(curl -s -o /dev/null -w '%{http_code}' http://$PUBLIC_IP)
    echo "   Request $i: HTTP $RESPONSE"
done
echo ""

echo "5. NAT Rules:"
az network lb inbound-nat-rule list -g $RESOURCE_GROUP --lb-name $LB_NAME \
    --query '[].{Name:name,FrontendPort:frontendPort,BackendPort:backendPort}' -o table

echo ""
echo "=== Validation Complete ==="
