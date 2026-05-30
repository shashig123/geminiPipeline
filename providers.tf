terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    # These will be passed via backend-config or environment variables in CI
  }
}

provider "azurerm" {
  features {}
}
