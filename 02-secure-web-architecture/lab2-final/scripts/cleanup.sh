#!/bin/bash
echo "Deleting rg-secure-web-prod..."
az group delete --name rg-secure-web-prod --yes --no-wait
echo "Cleanup initiated."
