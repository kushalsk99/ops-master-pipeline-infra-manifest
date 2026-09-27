###############################################################################
# modules/database/variables.tf
#
# Generic PostgreSQL connection variables.
# Works with any PostgreSQL backend: K3s-hosted, Cloud SQL, RDS, etc.
###############################################################################

variable "pg_host" {
  description = "Hostname or IP address of the PostgreSQL instance. For K3s in-cluster deployments this is typically the Kubernetes Service name or ClusterIP."
  type        = string
}

variable "pg_port" {
  description = "PostgreSQL port."
  type        = number
  default     = 5432
}

variable "pg_database" {
  description = "Name of the default database."
  type        = string
  default     = "ops_master"
}

variable "pg_username" {
  description = "PostgreSQL username."
  type        = string
  default     = "ops_user"
}

variable "pg_password" {
  description = "PostgreSQL password. Mark as sensitive; store in a secrets manager or Terraform Cloud variable set."
  type        = string
  sensitive   = true
}

variable "pg_ssl_mode" {
  description = "PostgreSQL SSL mode (disable | require | verify-ca | verify-full)."
  type        = string
  default     = "require"
}

variable "connection_name" {
  description = "Optional human-readable label for this connection (e.g. Cloud SQL connection string). Leave empty for non-GCP deployments."
  type        = string
  default     = ""
}
