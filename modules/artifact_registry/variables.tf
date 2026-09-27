###############################################################################
# modules/artifact_registry/variables.tf
###############################################################################

variable "project_id" {
  description = "GCP Project ID."
  type        = string
}

variable "region" {
  description = "GCP Region for Artifact Registry."
  type        = string
}

variable "repository_id" {
  description = "Identifier of the Artifact Registry repository."
  type        = string
}

variable "description" {
  description = "Description for the Artifact Registry repository."
  type        = string
  default     = "Container image registry for ops-master pipeline."
}

variable "create_repository" {
  description = "Whether to create a new Artifact Registry repository (true) or use an existing one (false)."
  type        = bool
  default     = false
}
