module "workload_identity_federation" {
  source = "../modules/workload_identity_federation"

  project_id  = var.project_id
  repos       = var.repo
  pool_id     = var.pool_id
  provider_id = var.provider_id
}