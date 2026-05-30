module "azure_infrastructure" {
  source          = "./modules/azure_infra"
  resource_groups = var.resource_groups
  acrs            = var.acrs
  aks_clusters    = var.aks_clusters
}

output "deployment_summary" {
  value = module.azure_infrastructure
}
