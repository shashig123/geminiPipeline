resource "azurerm_kubernetes_cluster" "aks" {
  for_each = var.aks_clusters

  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = each.value.dns_prefix
  kubernetes_version  = each.value.kubernetes_version

  default_node_pool {
    name       = each.value.default_node_pool.name
    node_count = each.value.default_node_pool.node_count
    vm_size    = each.value.default_node_pool.vm_size
  }

  identity {
    type = each.value.identity_type
  }

  dynamic "network_profile" {
    for_each = each.value.network_profile != null ? [each.value.network_profile] : []
    content {
      network_plugin = network_profile.value.network_plugin
      network_policy = network_profile.value.network_policy
    }
  }
}

output "aks_cluster_names" {
  value = { for k, v in azurerm_kubernetes_cluster.aks : k => v.name }
}

output "aks_cluster_fqdns" {
  value = { for k, v in azurerm_kubernetes_cluster.aks : k => v.fqdn }
}
