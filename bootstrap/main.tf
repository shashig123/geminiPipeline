terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "backend_rg_name" {
  default = "tfstate-rg"
}

variable "location" {
  default = "East US"
}

variable "storage_account_name" {
  default = "tfstate" # This must be globally unique, e.g., tfstate12345
}

variable "container_name" {
  default = "tfstate"
}

variable "service_principal_id" {
  description = "The Object ID of the Service Principal (not the Client ID)"
  type        = string
}

# 1. Create Resource Group for Backend
resource "azurerm_resource_group" "state_rg" {
  name     = var.backend_rg_name
  location = var.location
}

# 2. Create Storage Account
resource "azurerm_storage_account" "state_sa" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.state_rg.name
  location                 = azurerm_resource_group.state_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# 3. Create Container
resource "azurerm_storage_container" "state_container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.state_sa.name
  container_access_type = "private"
}

# 4. Assign Contributor Role to Service Principal on the Subscription (to manage resources)
data "azurerm_subscription" "primary" {}

resource "azurerm_role_assignment" "sp_contributor" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = var.service_principal_id
}

# 5. Assign Storage Blob Data Contributor Role (required for Terraform state management)
resource "azurerm_role_assignment" "sp_state_contributor" {
  scope                = azurerm_storage_account.state_sa.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.service_principal_id
}

output "backend_config" {
  value = {
    resource_group_name  = azurerm_resource_group.state_rg.name
    storage_account_name = azurerm_storage_account.state_sa.name
    container_name       = azurerm_storage_container.state_container.name
  }
}
