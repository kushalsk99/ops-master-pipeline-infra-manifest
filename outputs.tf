###############################################################################
# Root outputs.tf — GCE K3s & GitOps Infrastructure
###############################################################################

output "instance_name" {
  description = "Name of the K3s GCE instance."
  value       = module.k3s.instance_name
}

output "instance_external_ip" {
  description = "External public IPv4 address of the K3s server."
  value       = module.k3s.instance_external_ip
}

output "cluster_endpoint" {
  description = "K3s Kubernetes API server endpoint."
  value       = module.k3s.cluster_endpoint
}

output "artifact_registry_url" {
  description = "Full Docker-compatible URL of the Artifact Registry repository."
  value       = module.artifact_registry.repository_url
}

output "registry_host" {
  description = "Hostname for Google Artifact Registry."
  value       = module.artifact_registry.registry_host
}

output "k3s_service_account_email" {
  description = "Dedicated GCP Service Account for K3s and GAR reading."
  value       = module.iam.service_account_email
}

output "cicd_service_account_email" {
  description = "Email of the CI/CD pipeline service account for pushing images."
  value       = module.iam.cicd_service_account_email
}

output "argocd_server_url" {
  description = "Direct URL to access ArgoCD web UI via external IP (HTTP NodePort/Ingress or port-forward)."
  value       = "http://${module.k3s.instance_external_ip}"
}
