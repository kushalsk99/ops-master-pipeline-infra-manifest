###############################################################################
# modules/artifact_registry/variables.tf
###############################################################################

variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "Region where the repository will be created."
  type        = string
}

variable "repository_id" {
  description = "ID of the Artifact Registry repository."
  type        = string
}

variable "description" {
  description = "Human-readable description of the repository."
  type        = string
  default     = ""
}

variable "format" {
  description = "Repository format: DOCKER, MAVEN, NPM, PYTHON, APT, YUM, GO."
  type        = string
  default     = "DOCKER"
}
