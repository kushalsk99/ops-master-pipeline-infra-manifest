###############################################################################
# modules/artifact_registry/outputs.tf
###############################################################################

output "repository_id" {
  description = "The repository ID."
  value       = google_artifact_registry_repository.repo.repository_id
}

output "repository_url" {
  description = "Full Docker-compatible URL of the Artifact Registry repository."
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}"
}

output "registry_host" {
  description = "Hostname of the Artifact Registry (used for dockerconfigjson server)."
  value       = "${var.region}-docker.pkg.dev"
}
