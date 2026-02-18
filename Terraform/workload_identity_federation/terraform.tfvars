project_id = "<project-id>"

repo = {
  repo1 = {
    repository           = "RohithDhamu/DevSecOps_pipeline"
    service_account_name = "<service account name>"
    roles = [
  "roles/container.admin",
  "roles/artifactregistry.admin",
  "roles/iam.serviceAccountAdmin",
  "roles/iam.workloadIdentityPoolAdmin",
  "roles/serviceusage.serviceUsageAdmin"
  ]

  }
}

pool_id     = "github-action-pool"
provider_id = "github-actions-provider"
