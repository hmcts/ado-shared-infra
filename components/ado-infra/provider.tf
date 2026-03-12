locals {
  stg_subscription     = "74dacd4f-a248-45bb-a2f0-af700dc4cf68"
  preview_subscription = "1c4f0704-a29e-403d-b719-b90c34ef14c9"
}

terraform {

  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.7.0"
    }
  }

  required_version = "~> 1.4.0"
}


provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "azurerm" {
  features {}
  alias           = "workload_identity"
  subscription_id = var.env == "dev" ? local.stg_subscription : var.env == "preview" ? local.preview_subscription : var.subscription_id
}
