###############################################################################
# modules/artifact_registry/outputs.tf
###############################################################################

output "repository_id" {
  description = "The repository ID."
  value       = var.create_repository ? google_artifact_registry_repository.repo[0].repository_id : data.google_artifact_registry_repository.existing_repo[0].repository_id
}

output "repository_url" {
  description = "Full Docker-compatible URL of the Artifact Registry repository."
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_id}"
}

output "registry_host" {
  description = "Hostname of the Artifact Registry (used for dockerconfigjson server)."
  value       = "${var.region}-docker.pkg.dev"
}
