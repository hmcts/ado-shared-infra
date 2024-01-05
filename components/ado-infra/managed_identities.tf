locals {
  managed_identity_object_name = var.env == "ptlsbox" && var.area == "cft" ? "azure-devops-cftsbox-intsvc-mi" : var.env == "ptl" && var.area == "cft" ? "azure-devops-cftptl-intsvc-mi" : "azure-devops-${var.env}-mi"
}

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

  name = local.managed_identity_object_name
  tags = module.ctags.common_tags
}

resource "azurerm_role_assignment" "sops-kv-reader" {
  # DTS Bootstrap Principal_id
  principal_id         = azurerm_user_assigned_identity.azure-devops-mi.principal_id
  role_definition_name = "Reader"
  scope                = data.azurerm_key_vault.sops-kv.id
}

## data sources for MI/SDP app storage accounts 
data "azurerm_storage_account" "mi_landing_storage_account" {
  count = var.env == "prod" || var.env == "sbox" || var.env == "ptl" || var.env == "ptlsbox" ? 0 : 1

  name                = "milanding${var.env}"
  resource_group_name = "mi-${var.env}-rg"
}
data "azurerm_storage_account" "mi_persistent_storage_account" {
  count = var.env == "prod" || var.env == "sbox" || var.env == "ptl" || var.env == "ptlsbox" ? 0 : 1

  name                = "mipersistent${var.env}"
  resource_group_name = "mi-${var.env}-rg"
}
data "azurerm_storage_account" "mi_export_storage_account" {
  count = var.env == "prod" || var.env == "sbox" || var.env == "ptl" || var.env == "ptlsbox" ? 0 : 1

  name                = "miexport${var.env}"
  resource_group_name = "mi-${var.env}-rg"
}
data "azurerm_storage_account" "mi_polybasestaging_storage_account" {
  count = var.env == "prod" || var.env == "sbox" || var.env == "ptl" || var.env == "ptlsbox" ? 0 : 1

  name                = "mipolybasestaging${var.env}"
  resource_group_name = "mi-${var.env}-rg"
}
data "azurerm_storage_account" "mi_audit_storage_account" {
  count = var.env == "prod" || var.env == "sbox" || var.env == "ptl" || var.env == "ptlsbox" ? 0 : 1

  name                = "miaudit${var.env}"
  resource_group_name = "mi-${var.env}-rg"
}
data "azurerm_storage_account" "mi_adhoclanding_storage_account" {
  count = var.env == "prod" || var.env == "sbox" || var.env == "ptl" || var.env == "ptlsbox" ? 0 : 1

  name                = "miadhoclanding${var.env}"
  resource_group_name = "mi-${var.env}-rg"
}
data "azurerm_storage_account" "mi_apintegration_storage_account" {
  count = var.env == "sbox" || var.env == "ptl" || var.env == "ptlsbox" || var.env == "ithc" ? 0 : 1

  name                = "miapintegration${var.env}"
  resource_group_name = "mi-${var.env}-rg"
}
data "azurerm_storage_account" "mi_datasharelanding_storage_account" {
  count = var.env == "sbox" || var.env == "ptl" || var.env == "ptlsbox" ? 0 : 1

  name                = "midatasharelanding${var.env}"
  resource_group_name = "mi-${var.env}-rg"
}

## assigning permissions for SS Pipeline Agents Managed Identity for MI/SDP apps
resource "azurerm_role_assignment" "mi_landing_contributor" {
  count = var.env == "prod" || var.env == "sbox" || var.env == "ptl" || var.env == "ptlsbox" ? 0 : 1

  scope                = data.azurerm_storage_account.mi_landing_storage_account[count.index].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = local.managed_identity_object_name
}
resource "azurerm_role_assignment" "mi_pds_contributor" {
  count = var.env == "prod" || var.env == "sbox" || var.env == "ptl" || var.env == "ptlsbox" ? 0 : 1

  scope                = data.azurerm_storage_account.mi_persistent_storage_account[count.index].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = local.managed_identity_object_name
}
resource "azurerm_role_assignment" "mi_export_contributor" {
  count = var.env == "prod" || var.env == "sbox" || var.env == "ptl" || var.env == "ptlsbox" ? 0 : 1

  scope                = data.azurerm_storage_account.mi_export_storage_account[count.index].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = local.managed_identity_object_name
}
resource "azurerm_role_assignment" "mi_audit_contributor" {
  count = var.env == "prod" || var.env == "sbox" || var.env == "ptl" || var.env == "ptlsbox" ? 0 : 1

  scope                = data.azurerm_storage_account.mi_audit_storage_account[count.index].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = local.managed_identity_object_name
}
resource "azurerm_role_assignment" "mi_polybasestaging_contributor" {
  count = var.env == "prod" || var.env == "sbox" || var.env == "ptl" || var.env == "ptlsbox" ? 0 : 1

  scope                = data.azurerm_storage_account.mi_polybasestaging_storage_account[count.index].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = local.managed_identity_object_name
}
resource "azurerm_role_assignment" "mi_adhoc_contributor" {
  count = var.env == "prod" || var.env == "sbox" || var.env == "ptl" || var.env == "ptlsbox" ? 0 : 1

  scope                = data.azurerm_storage_account.mi_adhoclanding_storage_account[count.index].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = local.managed_identity_object_name
}
resource "azurerm_role_assignment" "aks_mi_apintegration_contributor" {
  count = var.env == "sbox" || var.env == "ptl" || var.env == "ptlsbox" || var.env == "ithc" ? 0 : 1

  scope                = data.azurerm_storage_account.mi_apintegration_storage_account[count.index].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = local.managed_identity_object_name
}
resource "azurerm_role_assignment" "aks_mi_datasharelanding_contributor" {
  count = var.env == "sbox" || var.env == "ptl" || var.env == "ptlsbox" ? 0 : 1

  scope                = data.azurerm_storage_account.mi_datasharelanding_storage_account[count.index].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = local.managed_identity_object_name
}