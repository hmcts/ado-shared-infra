variable "subscription_id" {
  description = "Subscription to run against"
  type        = string
}

variable "mi_resource_group" {
    description = "Managed Identity resource group"
    type = string
}

variable "sops_keyvault" {
    description = "Keyvault which holds sops-key"
    type = string
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

variable "mi_rg" {
  description = "Resource group that holds the Jenkins Managed Identity"
}