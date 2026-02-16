variable "project_id" {
  description = "The GCP project ID where resources will be created."
  type        = string
}

variable "region" {
  description = "GCP region for resources."
  type        = string
  default     = "us-central1"
}

# allowed_branches REMOVED — no longer needed or used
variable "repo" {
  description = "Map of GitHub repositories that use Workload Identity Federation."
  type = map(object({
    repository            = string           # e.g. "catalystinfolabs/mce-edits-api"
    service_account_name  = optional(string) # Auto-create if omitted
    service_account_email = optional(string) # Use existing SA
    roles                 = optional(list(string), [])
  }))

  validation {
    condition = alltrue([
      for k, r in var.repo : can(regex("^[^/]+/[^/]+$", r.repository))
    ])
    error_message = "Each repository must be in format 'owner/repo'."
  }
}

variable "pool_id" {
  description = "Workload Identity Pool ID."
  type        = string
  default     = "github-action-pool"
}

variable "provider_id" {
  description = "Workload Identity Provider ID."
  type        = string
  default     = "github-actions-provider"
}