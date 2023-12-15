data "azurerm_resource_group" "mi-rg" {
  name = var.mi_resource_group
}

resource "azurerm_user_assigned_identity" "azure-devops-mi" {
  resource_group_name = data.azurerm_resource_group.mi-rg.name
  location            = data.azurerm_resource_group.mi-rg.location

  name = "azure-devops-${var.env}-mi"
  tags = module.ctags.common_tags
}

resource "azurerm_role_assignment" "sops-kv-reader" {
  # DTS Bootstrap Principal_id
  principal_id         = azurerm_user_assigned_identity.azure-devops-mi.principal_id
  role_definition_name = "Reader"
  scope                = data.azurerm_key_vault.genesis_keyvault.id
}