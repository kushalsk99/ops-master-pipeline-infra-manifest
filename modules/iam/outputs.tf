###############################################################################
# modules/iam/outputs.tf
###############################################################################

output "service_account_email" {
  description = "Email address of the dedicated K3s / GAR reader service account."
  value       = google_service_account.k3s_sa.email
}

output "service_account_name" {
  description = "Fully qualified name of the dedicated K3s service account."
  value       = google_service_account.k3s_sa.name
}

output "cicd_service_account_email" {
  description = "Email address of the CI/CD pipeline service account."
  value       = google_service_account.cicd_sa.email
}
