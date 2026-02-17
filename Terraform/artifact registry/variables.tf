################
#  Project ID  #
################
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

####################################
#  Artifact Registry Repositories  #
####################################
variable "repositories" {
  type = map(object({
    location      = string # The region where the repository will be created
    repository_id = string # Unique identifier for the repository
    description   = string # Description of the repository
    format        = string # The format of the repository (e.g., DOCKER, MAVEN, NPM, etc.)
  }))
  default = {}
}