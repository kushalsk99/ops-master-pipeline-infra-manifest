###############################################################################
# modules/k3s/outputs.tf
###############################################################################

output "cluster_name" {
  description = "Logical name of the K3s cluster."
  value       = var.cluster_name
}

output "cluster_endpoint" {
  description = "K3s API server endpoint."
  value       = "https://${var.node_ip}:6443"
}

output "node_ip" {
  description = "IP address of the K3s server node."
  value       = var.node_ip
}

output "kubeconfig_path" {
  description = "Local path where the kubeconfig file was saved after bootstrap."
  value       = "${var.kubeconfig_output_dir}/${var.cluster_name}-kubeconfig.yaml"
}
