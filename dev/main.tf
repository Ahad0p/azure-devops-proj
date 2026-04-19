resource "azurerm_resource_group" "rg1" {
  name     = var.rgname
  location = var.location
}

module "ServicePrincipal" {
  source                 = "../modules/ServicePrincipal"
  service_principal_name = var.service_principal_name
}

resource "azurerm_role_assignment" "rolespn" {
  scope                = azurerm_resource_group.rg1.id
  role_definition_name = "Contributor"
  principal_id         = module.ServicePrincipal.service_principal_object_id
}

module "keyvault" {
  source                      = "../modules/keyvault"
  keyvault_name               = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.rgname
  service_principal_name      = var.service_principal_name
  service_principal_object_id = module.ServicePrincipal.service_principal_object_id
  service_principal_tenant_id = module.ServicePrincipal.service_principal_tenant_id
}

resource "azurerm_key_vault_secret" "example" {
  name         = "${var.service_principal_name}-client-secret"
  value        = module.ServicePrincipal.client_secret
  key_vault_id = module.keyvault.keyvault_id
}

module "aks" {
  source              = "../modules/aks/"
  service_principal_name = var.service_principal_name
  kubernetes_version = ""
  client_id           = module.ServicePrincipal.client_id
  client_secret       = module.ServicePrincipal.client_secret
  location            = var.location
  resource_group_name = var.rgname
  cluster_name        = var.cluster_name
  node_pool_name      = var.node_pool_name
}

resource "local_file" "kubeconfig" {
  filename        = "./kubeconfig"
  content         = module.aks.config
  file_permission = "0600"
}