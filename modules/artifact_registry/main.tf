###############################################################################
# modules/artifact_registry/main.tf
#
# Generic container registry configuration module.
#
# Instead of provisioning a GCP-specific Artifact Registry repository,
# this module accepts connection details for any OCI-compatible container
# registry (Docker Hub, GitHub Container Registry, self-hosted registry
# running inside K3s, GCR, ECR, etc.) and surfaces them as outputs for
# use in CI/CD pipelines and Kubernetes deployments.
#
# If you need to deploy a self-hosted registry inside K3s, deploy the
# "registry" Helm chart or the Docker registry image as a K3s manifest
# and point this module's variables at that endpoint.
###############################################################################

terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
  }
}

# Validate that the registry URL is set at plan time.
resource "null_resource" "registry_config" {
  triggers = {
    registry_url = var.registry_url
    repository   = var.repository
  }
}
