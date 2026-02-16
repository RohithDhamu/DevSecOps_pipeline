# variables.tf (in modules/workload-identity/)

variable "project_id" {
  description = "The GCP project ID where resources will be created."
  type        = string
  validation {
    condition     = length(var.project_id) > 0
    error_message = "project_id must not be empty."
  }
}

variable "repos" {
  description = <<-EOT
    Map of repositories that will use Workload Identity Federation.
    Each repo gets its own Service Account and token impersonation rights.
  EOT
  type = map(object({
    repository            = string           # e.g. "catalystinfolabs/mce-edits-api"
    service_account_name  = optional(string)  # If omitted, auto-generated
    service_account_email = optional(string)  # Use existing SA (full email)
    roles                 = list(string)     # GCP roles to grant (e.g. roles/container.developer)
  }))

  validation {
    condition = alltrue([
      for k, r in var.repos : can(regex("^[^/]+/[^/]+$", r.repository))
    ])
    error_message = "Each repository must be in format 'owner/repo'."
  }
}

variable "pool_id" {
  description = "Workload Identity Pool ID (e.g. github-action-pool)"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{4,30}$", var.pool_id))
    error_message = "pool_id must be 4–30 chars, lowercase letters, numbers, and hyphens only."
  }
}

variable "provider_id" {
  description = "Workload Identity Provider ID (e.g. github-actions-provider)"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{4,30}$", var.provider_id))
    error_message = "provider_id must be 4–30 chars, lowercase letters, numbers, and hyphens only."
  }
}