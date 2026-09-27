###############################################################################
# Root variables.tf
###############################################################################

variable "project_id" {
  description = "GCP project ID where all resources will be created."
  type        = string
}

variable "region" {
  description = "Default GCP region for resources."
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Deployment environment (e.g. production, staging, dev)."
  type        = string
  default     = "production"
}
