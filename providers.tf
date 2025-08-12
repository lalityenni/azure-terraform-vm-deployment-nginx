terraform {
  required_version = ">= 1.6.0"

    required_providers {
        azurerm = {
        source  = "hashicorp/azurerm"
        version = "~> 4.0"
        }
        random = {
        source  = "hashicorp/random"
        version = "~> 3.0"
        }
    }
}

provider "azurerm" {
  features {}
  subscription_id = "82a05eb1-1a7d-4ab2-b602-2b6e43278757"
}
