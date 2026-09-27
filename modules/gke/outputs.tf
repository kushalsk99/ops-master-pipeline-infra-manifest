###############################################################################
# modules/gke/outputs.tf
###############################################################################

output "cluster_name" {
  description = "Name of the GKE cluster."
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "API server endpoint of the GKE cluster."
  value       = google_container_cluster.primary.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Base64-encoded CA certificate of the GKE cluster."
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "workload_identity_pool" {
  description = "Workload Identity Pool identifier for IAM binding."
  value       = "${var.project_id}.svc.id.goog"
}
