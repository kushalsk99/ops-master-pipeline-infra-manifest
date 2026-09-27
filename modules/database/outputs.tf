###############################################################################
# modules/database/outputs.tf
###############################################################################

output "connection_name" {
  description = "Cloud SQL connection name (project:region:instance) for use with Cloud SQL Auth Proxy."
  value       = google_sql_database_instance.main.connection_name
}

output "private_ip" {
  description = "Private IP address of the Cloud SQL instance."
  value       = google_sql_database_instance.main.private_ip_address
  sensitive   = true
}

output "instance_name" {
  description = "Name of the Cloud SQL instance."
  value       = google_sql_database_instance.main.name
}
