###############################################################################
# modules/artifact_registry/main.tf
###############################################################################

# Reference existing repository if create_repository is false
data "google_artifact_registry_repository" "existing_repo" {
  count         = var.create_repository ? 0 : 1
  project       = var.project_id
  location      = var.region
  repository_id = var.repository_id
}

# Provision new repository only if create_repository is true
resource "google_artifact_registry_repository" "repo" {
  count         = var.create_repository ? 1 : 0
  project       = var.project_id
  location      = var.region
  repository_id = var.repository_id
  description   = var.description
  format        = "DOCKER"

  labels = {
    managed-by = "terraform"
  }
}
