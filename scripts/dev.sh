#!/bin/bash

set -e

RESOURCE_GROUP_NAME=terraform-state-rg
LOCATION=centralindia

DEV_SA_ACCOUNT=tfdevbackendabdul
STAGE_SA_ACCOUNT=tfstagebackendabdul
CONTAINER_NAME=tfstate

# # Login
# az login

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create storage account for staging
az storage account create \
  --resource-group $RESOURCE_GROUP_NAME \
  --name $STAGE_SA_ACCOUNT \
  --sku Standard_LRS \
  --encryption-services blob

# Create storage account for dev
az storage account create \
  --resource-group $RESOURCE_GROUP_NAME \
  --name $DEV_SA_ACCOUNT \
  --sku Standard_LRS \
  --encryption-services blob

# Create containers
az storage container create \
  --name $CONTAINER_NAME \
  --account-name $STAGE_SA_ACCOUNT \
  --auth-mode login

az storage container create \
  --name $CONTAINER_NAME \
  --account-name $DEV_SA_ACCOUNT \
  --auth-mode login

# Output
echo "Stage Storage Account: $STAGE_SA_ACCOUNT"
echo "Dev Storage Account: $DEV_SA_ACCOUNT"