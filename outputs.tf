###############################################################################
# Root outputs.tf
###############################################################################

output "cluster_endpoint" {
  description = "GKE cluster API server endpoint."
  value       = module.gke.cluster_endpoint
  sensitive   = true
}

output "artifact_registry_url" {
  description = "Full Docker-compatible URL of the Artifact Registry repository."
  value       = module.artifact_registry.repository_url
}

output "database_connection_name" {
  description = "Cloud SQL connection name (project:region:instance) for use with Cloud SQL Auth Proxy."
  value       = module.database.connection_name
}

output "ci_service_account_email" {
  description = "Email of the CI/CD pipeline service account."
  value       = module.iam.cicd_service_account_email
}
