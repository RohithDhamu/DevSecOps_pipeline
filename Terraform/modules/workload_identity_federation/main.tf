locals {
  # Support multiple repository owners
  unique_owners = distinct([for repo in var.repos : split("/", repo.repository)[0]])
  owner_conditions = length(local.unique_owners) > 0 ? join(" || ", [for o in local.unique_owners : "assertion.repository_owner == '${o}'"]) : "true"

  # Unique repositories only (NO branches!)
  unique_repos = distinct([for repo in var.repos : repo.repository])
  repo_conditions = length(local.unique_repos) > 0 ? join(" || ", [for r in local.unique_repos : "assertion.repository == '${r}'"]) : "true"

  # Remove branch logic completely — we don't need it
  # bindings now per-repo only
  bindings = [
    for repo_key, repo in var.repos : {
      repo_key   = repo_key
      repository = repo.repository
    }
  ]

  # SA emails/names (unchanged)
  sa_emails = merge(
    { for k, v in google_service_account.sa : k => v.email },
    { for k, v in var.repos : k => lookup(v, "service_account_email", null) if lookup(v, "service_account_email", null) != null }
  )
  sa_names = merge(
    { for k, v in google_service_account.sa : k => v.name },
    { for k, v in var.repos : k => "projects/${var.project_id}/serviceAccounts/${lookup(v, "service_account_email", null)}" if lookup(v, "service_account_email", null) != null }
  )
}

resource "google_iam_workload_identity_pool" "pool" {
  workload_identity_pool_id = var.pool_id
  display_name              = "GitHub Actions Pool"
  description               = "Workload Identity Pool for GitHub Actions"
  disabled                  = false
}

resource "google_iam_workload_identity_pool_provider" "provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.provider_id
  display_name                       = "GitHub Actions Provider"
  description                        = "OIDC Provider for GitHub Actions"

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
    "attribute.actor"            = "assertion.actor"
    "attribute.aud"              = "assertion.aud"
    "attribute.ref"              = "assertion.ref"  # Keep for debugging
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  # REMOVED branch_conditions — only repo & owner
  attribute_condition = "${local.owner_conditions} && ${local.repo_conditions}"
}

resource "google_service_account" "sa" {
  for_each = { for k, v in var.repos : k => v if lookup(v, "service_account_email", null) == null }

  account_id   = each.value.service_account_name
  display_name = "GitHub Actions SA for ${each.value.repository}"
  description  = "Used by GitHub Actions in ${each.value.repository}"
}

resource "google_project_iam_member" "roles" {
  for_each = { for entry in flatten([
    for repo_key, repo in var.repos : [
      for role in repo.roles : {
        key   = "${repo_key}-${role}"
        role  = role
        email = local.sa_emails[repo_key]
      }
    ] if lookup(repo, "service_account_email", null) == null
  ]) : entry.key => entry }

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${each.value.email}"
}

# FIXED: Allow ALL pushes (branch + tag) from the repository
resource "google_service_account_iam_member" "token_creator_binding" {
  for_each = { for b in local.bindings : b.repo_key => b }

  service_account_id = local.sa_names[each.value.repo_key]
  role               = "roles/iam.serviceAccountTokenCreator"

  # ONLY REPO — no branch, no ref → works for tags AND branches
  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.pool.name}/attribute.repository/${each.value.repository}"
}