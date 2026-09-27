###############################################################################
# modules/database/outputs.tf
###############################################################################

output "connection_name" {
  description = "Human-readable connection label (e.g. GCP Cloud SQL connection name, or a descriptive tag for non-GCP deployments)."
  value       = var.connection_name != "" ? var.connection_name : "${var.pg_host}:${var.pg_port}/${var.pg_database}"
}

output "pg_host" {
  description = "PostgreSQL host."
  value       = var.pg_host
}

output "pg_port" {
  description = "PostgreSQL port."
  value       = var.pg_port
}

output "pg_database" {
  description = "PostgreSQL database name."
  value       = var.pg_database
}

output "pg_username" {
  description = "PostgreSQL username."
  value       = var.pg_username
}

output "pg_connection_string" {
  description = "Constructed PostgreSQL DSN (password excluded — inject separately)."
  value       = "postgresql://${var.pg_username}@${var.pg_host}:${var.pg_port}/${var.pg_database}?sslmode=${var.pg_ssl_mode}"
  sensitive   = true
}
