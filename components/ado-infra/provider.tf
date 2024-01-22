locals {
  stg_subscription = "74dacd4f-a248-45bb-a2f0-af700dc4cf68"
}

terraform {

  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.7.0"
    }
  }

  required_version = "~> 1.2.0"
}


provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "azurerm" {
  features {}
  alias           = "workload_identity"
  subscription_id = var.env == "dev" ? local.stg_subscription : var.subscription_id
}