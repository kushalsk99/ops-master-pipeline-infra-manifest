###############################################################################
# modules/database/variables.tf
###############################################################################

variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "Region where the Cloud SQL instance will be created."
  type        = string
}

variable "instance_name" {
  description = "Name of the Cloud SQL instance."
  type        = string
}

variable "database_version" {
  description = "Database engine version (e.g. POSTGRES_15, MYSQL_8_0)."
  type        = string
  default     = "POSTGRES_15"
}

variable "tier" {
  description = "Machine type / tier for the Cloud SQL instance."
  type        = string
  default     = "db-custom-2-7680"
}

variable "network" {
  description = "Self-link of the VPC network for private IP peering."
  type        = string
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection on the instance."
  type        = bool
  default     = true
}
