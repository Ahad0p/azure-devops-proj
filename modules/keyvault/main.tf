resource "random_id" "suffix" {
  byte_length = 4
}

resource "azurerm_key_vault" "vault" {
  name                = "${var.keyvault_name}-${random_id.suffix.hex}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = "standard"

  rbac_authorization_enabled = true
}

# Give AKS access to Key Vault (optional - pass from outside)
resource "azurerm_role_assignment" "aks_kv_access" {
  count               = var.aks_principal_id != "" ? 1 : 0
  scope               = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id        = var.aks_principal_id
}