#######################
#  Artifact Registry  #
#######################
resource "google_artifact_registry_repository" "artifact_registry" {
  for_each = var.repositories

  location      = each.value.location
  repository_id = each.value.repository_id
  description   = each.value.description
  format        = each.value.format
  project       = var.project_id
}