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

  name = var.env == "ptlsbox" && var.area == "cft" ? "azure-devops-cftsbox-intsvc-mi" : var.env == "ptl" && var.area == "cft" ? "azure-devops-cftptl-intsvc-mi" : "azure-devops-${var.env}-mi"
  tags = module.ctags.common_tags
}

resource "azurerm_role_assignment" "sops-kv-reader" {
  # DTS Bootstrap Principal_id
  principal_id         = azurerm_user_assigned_identity.azure-devops-mi.principal_id
  role_definition_name = "Reader"
  scope                = data.azurerm_key_vault.sops-kv.id
}