variable "location" {
  description = "Artifact Registry location for repository-level bindings"
  type        = string
  default     = "us-central1"
}

variable "project" {
  description = "GCP project id where the service account and bindings will be created"
  type        = string
}

variable "name" {
  description = "Service account id (e.g. 'gke-node-sa')"
  type        = string
  default     = "gke-node-sa"
}

variable "display_name" {
  description = "Display name for the created service account"
  type        = string
  default     = "GKE Node Service Account"
}

variable "bind_project_roles" {
  description = "If true, attach the roles in project_roles at project-level to the created SA"
  type        = bool
  default     = true
}

variable "project_roles" {
  description = "List of project-level roles to bind to the created service account (e.g. roles/artifactregistry.reader)"
  type        = list(string)
  default     = ["roles/artifactregistry.reader"]
}

variable "repo_bindings" {
  description = "Map of repository name -> list(role strings). If provided, repository-level IAM bindings will be created. Example: { \"my-repo\" = [\"roles/artifactregistry.reader\"] }"
  type        = map(list(string))
  default     = {}
}
