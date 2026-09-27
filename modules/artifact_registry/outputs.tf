###############################################################################
# modules/artifact_registry/outputs.tf
###############################################################################

output "repository_id" {
  description = "Fully qualified repository identifier (<registry_url>/<repository>)."
  value       = "${var.registry_url}/${var.repository}"
}

output "repository_url" {
  description = "Full URL to the container image repository, ready to use as an image prefix in Kubernetes manifests and CI/CD pipelines."
  value       = "${var.registry_url}/${var.repository}"
}

output "registry_url" {
  description = "Base URL of the container registry."
  value       = var.registry_url
}

output "is_insecure" {
  description = "Whether the registry uses a self-signed/insecure certificate."
  value       = var.is_insecure
}
