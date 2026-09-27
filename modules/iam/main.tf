###############################################################################
# modules/iam/main.tf
###############################################################################

# ── GKE Node Service Account ──────────────────────────────────────────────────

resource "google_service_account" "gke_sa" {
  project      = var.project_id
  account_id   = var.gke_sa_name
  display_name = "GKE Node Service Account (ops-master)"
}

resource "google_project_iam_member" "gke_sa_log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

resource "google_project_iam_member" "gke_sa_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

resource "google_project_iam_member" "gke_sa_monitoring_viewer" {
  project = var.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

resource "google_project_iam_member" "gke_sa_artifact_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

# ── Workload Identity Binding ─────────────────────────────────────────────────
# Allows the in-cluster KSA (kubernetes service account) to act as the GCP SA.

resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = google_service_account.gke_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.workload_identity_pool}"
}

# ── CI/CD Pipeline Service Account ───────────────────────────────────────────

resource "google_service_account" "cicd_sa" {
  project      = var.project_id
  account_id   = "ops-master-cicd"
  display_name = "CI/CD Pipeline Service Account (ops-master)"
}

resource "google_project_iam_member" "cicd_sa_artifact_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.cicd_sa.email}"
}

resource "google_project_iam_member" "cicd_sa_gke_developer" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.cicd_sa.email}"
}
