###############################################################################
# modules/iam/outputs.tf
###############################################################################

output "gke_service_account_email" {
  description = "Email of the GKE node service account."
  value       = google_service_account.gke_sa.email
}

output "cicd_service_account_email" {
  description = "Email of the CI/CD pipeline service account."
  value       = google_service_account.cicd_sa.email
}
