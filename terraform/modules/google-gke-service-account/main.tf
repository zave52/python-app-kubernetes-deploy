resource "google_service_account" "sa" {
  account_id   = var.name
  project      = var.project
  display_name = var.display_name
}

resource "google_project_iam_member" "project_roles" {
  for_each = var.bind_project_roles ? toset(var.project_roles) : {}

  project = var.project
  role    = each.value
  member  = "serviceAccount:${google_service_account.sa.email}"
}

locals {
  repo_role_pairs = length(keys(var.repo_bindings)) > 0 ? flatten([
    for repo, roles in var.repo_bindings : [
      for r in roles : {
        repo = repo
        role = r
      }
    ]
  ]) : []
}

resource "google_artifact_registry_repository_iam_member" "repo_roles" {
  for_each = { for pair in local.repo_role_pairs : "${pair.repo}__${replace(pair.role, "/", "_")}" => pair }

  project    = var.project
  location   = var.location
  repository = each.value.repo
  role       = each.value.role
  member     = "serviceAccount:${google_service_account.sa.email}"
}
