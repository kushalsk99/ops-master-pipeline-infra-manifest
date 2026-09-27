###############################################################################
# modules/artifact_registry/outputs.tf
###############################################################################

output "repository_id" {
  description = "Fully qualified Artifact Registry repository ID."
  value       = google_artifact_registry_repository.repo.id
}

output "repository_url" {
  description = "Full Docker-compatible URL of the repository."
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_id}"
}
