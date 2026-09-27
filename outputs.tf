###############################################################################
# Root outputs.tf — K3s-native infrastructure
###############################################################################

output "cluster_endpoint" {
  description = "K3s API server endpoint (https://<node-ip>:6443)."
  value       = module.k3s.cluster_endpoint
}

output "kubeconfig_path" {
  description = "Local path of the saved kubeconfig for this cluster."
  value       = module.k3s.kubeconfig_path
}

output "artifact_registry_url" {
  description = "Full container image repository URL (<registry>/<repo>)."
  value       = module.artifact_registry.repository_url
}

output "database_connection_name" {
  description = "PostgreSQL connection label (host:port/database)."
  value       = module.database.connection_name
}
