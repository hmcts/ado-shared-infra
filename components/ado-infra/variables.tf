variable "subscription_id" {
  description = "Subscription to run against"
  type        = string
}

variable "area" {
  description = "area var passed by ado pipeline (cft/sds)"
  type        = string
}

variable "mi_resource_group" {
  description = "Managed Identity resource group"
  type        = string
}

variable "mi_storage_account_prefixes_nonprod" {
  description = "List of MI/SDP storage account prefixes for permission assignment in non-prod envs"
  type        = list(string)
  default     = ["milanding", "mipersistent", "miexport", "miaudit", "miadhoclanding", "miapintegration", "midatasharelanding"]
}

variable "mi_storage_account_prefixes_prod" {
  description = "List of MI/SDP storage account prefixes for permission assignment in prod env"
  type        = list(string)
  default     = ["miapintegration", "midatasharelanding"]
}

variable "sops_keyvault" {
  description = "Keyvault which holds sops-key"
  type        = string
}

variable "env" {
  description = "Name of the environment to deploy the resource"
  type        = string
}

variable "product" {
  description = "Name of the product"
  type        = string
}

variable "builtFrom" {
  description = "Name of the GitHub repository this application is being built from"
  type        = string
}

variable "location" {
  description = "Azure location to deploy the resource"
  type        = string
  default     = "UK South"
}

variable "expiresAfter" {
  description = "Expiration date"
  default     = "3000-01-01"
}