#######################
#  Artifact Registry  #
#######################
module "artifact_registry" {
  source       = "../modules/artifact-registry"
  project_id   = var.project_id
  repositories = var.repositories
}