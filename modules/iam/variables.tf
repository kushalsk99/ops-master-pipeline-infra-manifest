###############################################################################
# modules/iam/variables.tf
###############################################################################

variable "project_id" {
  description = "GCP Project ID."
  type        = string
}

variable "sa_name" {
  description = "Account ID for the dedicated K3s / GAR reader service account."
  type        = string
  default     = "k3s-gar-reader-sa"
}
