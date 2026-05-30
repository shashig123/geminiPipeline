resource "azurerm_container_registry" "acr" {
  for_each = var.acrs

  name                = each.key
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  sku                 = each.value.sku
  admin_enabled       = each.value.admin_enabled

  dynamic "georeplications" {
    for_each = each.value.georeplications
    content {
      location                = georeplications.value.location
      zone_redundancy_enabled = georeplications.value.zone_redundancy_enabled
      tags                    = georeplications.value.tags
    }
  }
}

output "acr_ids" {
  value = { for k, v in azurerm_container_registry.acr : k => v.id }
}

output "acr_login_servers" {
  value = { for k, v in azurerm_container_registry.acr : k => v.login_server }
}
