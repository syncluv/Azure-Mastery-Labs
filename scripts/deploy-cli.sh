#!/bin/bash
#===============================================================================
# Azure Public Load Balancer Lab - Deployment Script
# Author: Charles
# Description: Deploys a complete load balancer infrastructure with 3 web servers
#===============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Azure Load Balancer Lab - Deployment${NC}"
echo -e "${GREEN}========================================${NC}"

# Configuration Variables
export RESOURCE_GROUP="rg-lb-lab-prod"
export LOCATION="eastus2"
export VNET_NAME="vnet-lb-lab"
export SUBNET_NAME="snet-backend"
export LB_NAME="lb-web-prod"
export PIP_NAME="pip-lb-web"
export AVSET_NAME="avset-web"
export NSG_NAME="nsg-backend"
export ADMIN_USER="azureadmin"

# Generate secure password
export ADMIN_PASSWORD=$(openssl rand -base64 16)!Aa1
echo -e "${YELLOW}Admin password saved to ~/lb-lab-credentials.txt${NC}"
echo "Admin Username: $ADMIN_USER" > ~/lb-lab-credentials.txt
echo "Admin Password: $ADMIN_PASSWORD" >> ~/lb-lab-credentials.txt
chmod 600 ~/lb-lab-credentials.txt

# Step 1: Create Resource Group
echo -e "\n${GREEN}[1/8] Creating Resource Group...${NC}"
az group create \
    --name $RESOURCE_GROUP \
    --location $LOCATION \
    --tags Environment=Lab Project=LoadBalancer

# Step 2: Create Virtual Network
echo -e "\n${GREEN}[2/8] Creating Virtual Network...${NC}"
az network vnet create \
    --resource-group $RESOURCE_GROUP \
    --name $VNET_NAME \
    --address-prefix 10.0.0.0/16 \
    --subnet-name $SUBNET_NAME \
    --subnet-prefix 10.0.1.0/24

# Step 3: Create NSG
echo -e "\n${GREEN}[3/8] Creating Network Security Group...${NC}"
az network nsg create \
    --resource-group $RESOURCE_GROUP \
    --name $NSG_NAME

az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_NAME \
    --name Allow-HTTP \
    --priority 100 \
    --destination-port-ranges 80 \
    --protocol Tcp \
    --access Allow

az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_NAME \
    --name Allow-SSH-LB \
    --priority 120 \
    --source-address-prefixes AzureLoadBalancer \
    --destination-port-ranges 22 \
    --protocol Tcp \
    --access Allow

az network vnet subnet update \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $VNET_NAME \
    --name $SUBNET_NAME \
    --network-security-group $NSG_NAME

# Step 4: Create Availability Set
echo -e "\n${GREEN}[4/8] Creating Availability Set...${NC}"
az vm availability-set create \
    --resource-group $RESOURCE_GROUP \
    --name $AVSET_NAME \
    --platform-fault-domain-count 2 \
    --platform-update-domain-count 5

# Step 5: Create VMs
echo -e "\n${GREEN}[5/8] Creating Virtual Machines...${NC}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for i in 1 2 3; do
    echo "Creating vm-web-$i..."
    az vm create \
        --resource-group $RESOURCE_GROUP \
        --name vm-web-$i \
        --availability-set $AVSET_NAME \
        --vnet-name $VNET_NAME \
        --subnet $SUBNET_NAME \
        --image Ubuntu2204 \
        --size Standard_B2s \
        --admin-username $ADMIN_USER \
        --admin-password "$ADMIN_PASSWORD" \
        --public-ip-address "" \
        --nsg "" \
        --custom-data "$SCRIPT_DIR/cloud-init.yaml" \
        --no-wait
done

echo "Waiting for VMs to be created..."
for i in 1 2 3; do
    az vm wait --created --resource-group $RESOURCE_GROUP --name vm-web-$i
done

# Step 6: Create Load Balancer
echo -e "\n${GREEN}[6/8] Creating Load Balancer...${NC}"
az network public-ip create \
    --resource-group $RESOURCE_GROUP \
    --name $PIP_NAME \
    --sku Standard \
    --allocation-method Static \
    --zone 1 2 3

az network lb create \
    --resource-group $RESOURCE_GROUP \
    --name $LB_NAME \
    --sku Standard \
    --public-ip-address $PIP_NAME \
    --frontend-ip-name frontend-web \
    --backend-pool-name backend-pool-web

# Step 7: Configure Health Probe and Rules
echo -e "\n${GREEN}[7/8] Configuring Health Probe and Rules...${NC}"
az network lb probe create \
    --resource-group $RESOURCE_GROUP \
    --lb-name $LB_NAME \
    --name probe-http \
    --protocol Http \
    --port 80 \
    --path /health \
    --interval 5 \
    --probe-threshold 2

az network lb rule create \
    --resource-group $RESOURCE_GROUP \
    --lb-name $LB_NAME \
    --name rule-http \
    --protocol Tcp \
    --frontend-port 80 \
    --backend-port 80 \
    --frontend-ip-name frontend-web \
    --backend-pool-name backend-pool-web \
    --probe-name probe-http \
    --idle-timeout 15 \
    --enable-tcp-reset true

# Create NAT rules
for i in 1 2 3; do
    az network lb inbound-nat-rule create \
        --resource-group $RESOURCE_GROUP \
        --lb-name $LB_NAME \
        --name nat-ssh-vm$i \
        --protocol Tcp \
        --frontend-port 5000$i \
        --backend-port 22 \
        --frontend-ip-name frontend-web
done

# Step 8: Add VMs to Backend Pool
echo -e "\n${GREEN}[8/8] Adding VMs to Backend Pool...${NC}"
for i in 1 2 3; do
    NIC_ID=$(az vm show \
        --resource-group $RESOURCE_GROUP \
        --name vm-web-$i \
        --query 'networkProfile.networkInterfaces[0].id' -o tsv)
    
    az network nic ip-config update \
        --ids "${NIC_ID}/ipConfigurations/ipconfigvm-web-$i" \
        --lb-address-pools backend-pool-web \
        --lb-inbound-nat-rules nat-ssh-vm$i \
        --lb-name $LB_NAME
done

# Create outbound rule
az network lb outbound-rule create \
    --resource-group $RESOURCE_GROUP \
    --lb-name $LB_NAME \
    --name outbound-rule-web \
    --frontend-ip-configs frontend-web \
    --protocol All \
    --idle-timeout 15 \
    --outbound-ports 10000 \
    --address-pool backend-pool-web

# Get Public IP
PUBLIC_IP=$(az network public-ip show \
    --resource-group $RESOURCE_GROUP \
    --name $PIP_NAME \
    --query ipAddress -o tsv)

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "Public IP: ${YELLOW}$PUBLIC_IP${NC}"
echo -e "Web URL: ${YELLOW}http://$PUBLIC_IP${NC}"
echo -e "\nSSH Access:"
echo -e "  vm-web-1: ssh $ADMIN_USER@$PUBLIC_IP -p 50001"
echo -e "  vm-web-2: ssh $ADMIN_USER@$PUBLIC_IP -p 50002"
echo -e "  vm-web-3: ssh $ADMIN_USER@$PUBLIC_IP -p 50003"
echo -e "\nCredentials saved to: ~/lb-lab-credentials.txt"
