module "resource_group" {
  source          = "../resource_group"
  resource_groups = var.resource_groups
}

module "acr" {
  source = "../acr"
  acrs   = var.acrs

  depends_on = [module.resource_group]
}

module "aks" {
  source       = "../aks"
  aks_clusters = var.aks_clusters

  depends_on = [module.resource_group]
}

output "rg_info" {
  value = module.resource_group.resource_group_names
}

output "acr_info" {
  value = module.acr.acr_login_servers
}

output "aks_info" {
  value = module.aks.aks_cluster_fqdns
}
