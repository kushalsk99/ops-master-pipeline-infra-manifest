###############################################################################
# modules/iam/variables.tf
###############################################################################

variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "gke_sa_name" {
  description = "Short account ID for the GKE node service account."
  type        = string
}

variable "artifact_registry_repo" {
  description = "Fully qualified Artifact Registry repository ID."
  type        = string
}

variable "workload_identity_pool" {
  description = "Workload Identity Pool identifier (e.g. project.svc.id.goog)."
  type        = string
}
