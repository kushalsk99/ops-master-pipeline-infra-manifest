###############################################################################
# modules/k3s/variables.tf
###############################################################################

variable "project_id" {
  description = "GCP Project ID."
  type        = string
}

variable "zone" {
  description = "GCP compute zone where the K3s instance will run."
  type        = string
}

variable "cluster_name" {
  description = "Logical name for the K3s cluster and instance."
  type        = string
  default     = "k3s-server"
}

variable "machine_type" {
  description = "GCE machine type for the K3s server."
  type        = string
  default     = "e2-standard-4"
}

variable "subnetwork_id" {
  description = "VPC Subnetwork ID where the VM will be deployed."
  type        = string
}

variable "service_account_email" {
  description = "Email of the dedicated GCP Service Account attached to the VM."
  type        = string
}

variable "k3s_version" {
  description = "K3s version to install."
  type        = string
  default     = "v1.30.2+k3s1"
}

variable "registry_host" {
  description = "GAR Docker host (e.g. us-central1-docker.pkg.dev)."
  type        = string
}

variable "gitops_repo_url" {
  description = "GitOps repository URL containing application manifests."
  type        = string
}

variable "gitops_path" {
  description = "Path within the GitOps repository for the root application."
  type        = string
  default     = "."
}

variable "gitops_target_revision" {
  description = "Target revision/branch of the GitOps repository."
  type        = string
  default     = "HEAD"
}
