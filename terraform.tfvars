resource_groups = {
  "my-rg-1" = {
    location = "East US"
    tags     = { Environment = "Dev" }
  }
}

acrs = {
  "myacr2026test" = {
    resource_group_name = "my-rg-1"
    location            = "East US"
    sku                 = "Premium"
    admin_enabled       = true
    georeplications     = [
      {
        location                = "West US"
        zone_redundancy_enabled = true
        tags                    = { Region = "West" }
      }
    ]
  }
}

aks_clusters = {
  "my-aks-cluster" = {
    resource_group_name = "my-rg-1"
    location            = "East US"
    dns_prefix          = "myaks"
    kubernetes_version  = "1.27.3"
    default_node_pool   = {
      name       = "default"
      node_count = 1
      vm_size    = "Standard_DS2_v2"
    }
    identity_type = "SystemAssigned"
  }
}
