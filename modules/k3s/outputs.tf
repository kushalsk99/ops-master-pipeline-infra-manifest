###############################################################################
# modules/k3s/outputs.tf
###############################################################################

output "instance_name" {
  description = "Name of the K3s GCE instance."
  value       = google_compute_instance.k3s_server.name
}

output "instance_id" {
  description = "Server-assigned unique identifier of the GCE instance."
  value       = google_compute_instance.k3s_server.instance_id
}

output "instance_external_ip" {
  description = "External public IPv4 address of the K3s server."
  value       = google_compute_instance.k3s_server.network_interface[0].access_config[0].nat_ip
}

output "instance_internal_ip" {
  description = "Internal private IPv4 address of the K3s server."
  value       = google_compute_instance.k3s_server.network_interface[0].network_ip
}

output "cluster_endpoint" {
  description = "K3s Kubernetes API endpoint."
  value       = "https://${google_compute_instance.k3s_server.network_interface[0].access_config[0].nat_ip}:6443"
}
