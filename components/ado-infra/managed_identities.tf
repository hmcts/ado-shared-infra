module "ctags" {
  source       = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment  = var.env
  product      = "${var.area}-platform"
  builtFrom    = var.builtFrom
  expiresAfter = "3000-01-01"
}

data "azurerm_resource_group" "mi-rg" {
  name = var.mi_resource_group
}

data "azurerm_key_vault" "sops-kv" {
  name                = var.sops_keyvault
  resource_group_name = "genesis-rg"

}
resource "azurerm_user_assigned_identity" "azure-devops-mi" {
  resource_group_name = data.azurerm_resource_group.mi-rg.name
  location            = data.azurerm_resource_group.mi-rg.location

  name = var.aks_managed_identity_object_name
  tags = module.ctags.common_tags
}

resource "azurerm_role_assignment" "sops-kv-reader" {
  # DTS Bootstrap Principal_id
  principal_id         = azurerm_user_assigned_identity.azure-devops-mi.principal_id
  role_definition_name = "Reader"
  scope                = data.azurerm_key_vault.sops-kv.id
}

## assigning permissions for SS Pipeline Agents Managed Identity for MI/SDP apps in non-prod
data "azurerm_storage_account" "mi_landing_storage_accounts_nonprod" {
  for_each = { for sa in var.mi_storage_account_prefixes_nonprod : sa => sa if contains(var.mi_storage_account_prefixes_nonprod, sa) }
  count    = var.env == "prod" ? 0 : 1

  name                = "${each.key}${var.env}"
  resource_group_name = "mi-${var.env}-rg"
}

resource "azurerm_role_assignment" "storage_account_role_assignment_nonprod" {
  for_each = data.azurerm_storage_account.mi_landing_storage_accounts_nonprod
  count    = var.env == "prod" ? 0 : 1

  scope                = each.value.id
  principal_id         = azurerm_user_assigned_identity.azure-devops-mi.principal_id
  role_definition_name = "Storage Blob Data Contributor"
}

## assigning permissions for SS Pipeline Agents Managed Identity for MI/SDP apps in prod
data "azurerm_storage_account" "mi_landing_storage_accounts_prod" {
  for_each = { for sa in var.mi_storage_account_prefixes_prod : sa => sa if contains(var.mi_storage_account_prefixes_prod, sa) }
  count    = var.env == "prod" ? 1 : 0

  name                = "${each.key}${var.env}"
  resource_group_name = "mi-${var.env}-rg"
}

resource "azurerm_role_assignment" "storage_account_role_assignment_prod" {
  for_each = data.azurerm_storage_account.mi_landing_storage_accounts_prod
  count    = var.env == "prod" ? 1 : 0

  scope                = each.value.id
  principal_id         = azurerm_user_assigned_identity.azure-devops-mi.principal_id
  role_definition_name = "Storage Blob Data Contributor"
}