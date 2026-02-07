#!/bin/bash
#===============================================================================
# Azure Load Balancer Lab - Cleanup Script
#===============================================================================

echo "Deleting resource group rg-lb-lab-prod..."
az group delete --name rg-lb-lab-prod --yes --no-wait

echo "Cleanup initiated. This may take 5-10 minutes."
rm -f ~/lb-lab-credentials.txt
echo "Local credentials file removed."
