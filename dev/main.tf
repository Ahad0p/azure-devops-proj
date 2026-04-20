data "azurerm_client_config" "current" {}

# 1. Resource Group
resource "azurerm_resource_group" "rg1" {
  name     = var.rgname
  location = var.location
}

# 2. AKS Module
module "aks" {
  source              = "../modules/aks"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg1.name
  cluster_name        = var.cluster_name

  dns_prefix = "dev-aks"
  node_count = 1
  vm_size    = "Standard_B2s"
  environment = "dev"
}

# 3. Key Vault Module
module "keyvault" {
  source              = "../modules/keyvault"
  keyvault_name       = var.keyvault_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg1.name

  tenant_id = data.azurerm_client_config.current.tenant_id
}

# 4. Role Assignment (AKS → Key Vault)
resource "azurerm_role_assignment" "aks_kv_access" {
  scope                = module.keyvault.keyvault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.aks.principal_id
}

# 5. Kubeconfig
resource "local_file" "kubeconfig" {
  filename        = "./kubeconfig"
  content         = module.aks.config
  file_permission = "0600"
}