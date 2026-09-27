###############################################################################
# Root variables.tf — GCE K3s & GitOps Infrastructure
###############################################################################

# ── GCP Project & Regional Coordinates ───────────────────────────────────────

variable "project_id" {
  description = "Google Cloud Project ID where all resources are provisioned."
  type        = string
}

variable "region" {
  description = "Default GCP Region."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Default GCP Zone for the GCE compute instance."
  type        = string
  default     = "us-central1-a"
}

variable "environment" {
  description = "Deployment environment name (e.g. production, staging, dev)."
  type        = string
  default     = "production"
}

# ── Artifact Registry Configuration ──────────────────────────────────────────

variable "artifact_repo_name" {
  description = "Name of the Artifact Registry Docker repository."
  type        = string
  default     = "opsmaster-pipeline"
}

variable "create_artifact_repo" {
  description = "Set to true to provision a new Artifact Registry repo, or false to use your existing one."
  type        = bool
  default     = false
}

# ── IAM Configuration ────────────────────────────────────────────────────────

variable "manage_iam" {
  description = "Whether Terraform should manage project-level IAM bindings (set to false if the runner lacks Project IAM Admin)."
  type        = bool
  default     = false
}

# ── Compute / K3s Configuration ──────────────────────────────────────────────

variable "machine_type" {
  description = "GCE Machine Type for the K3s cluster node."
  type        = string
  default     = "e2-standard-4"
}

variable "k3s_version" {
  description = "K3s release version (https://github.com/k3s-io/k3s/releases)."
  type        = string
  default     = "v1.30.2+k3s1"
}

# ── GitOps / ArgoCD Configuration ────────────────────────────────────────────

variable "gitops_repo_url" {
  description = "GitOps repository URL containing application manifests and Linkerd configurations."
  type        = string
  default     = "https://github.com/kushalsk99/ops-master-pipeline-argo-gitops.git"
}

variable "gitops_path" {
  description = "Root directory path within the GitOps repository for the root ArgoCD Application."
  type        = string
  default     = "."
}

variable "gitops_target_revision" {
  description = "Git target revision (branch, tag, or commit hash) for the root ArgoCD Application."
  type        = string
  default     = "HEAD"
}

# ── Networking & Security ────────────────────────────────────────────────────

variable "admin_source_ranges" {
  description = "CIDR ranges allowed to access administrative ports (K3s API:6443, SSH:22)."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
