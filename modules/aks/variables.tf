variable "aks_clusters" {
  type = map(object({
    resource_group_name = string
    location            = string
    dns_prefix          = string
    kubernetes_version  = string
    default_node_pool   = object({
      name       = string
      node_count = number
      vm_size    = string
    })
    identity_type = string
    network_profile = optional(object({
      network_plugin = string
      network_policy = string
    }))
  }))
}
