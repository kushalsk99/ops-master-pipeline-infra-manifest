###############################################################################
# modules/iam/main.tf
#
# Dedicated Service Accounts and IAM bindings for K3s GCE VM and CI/CD.
###############################################################################

# ── Dedicated K3s Node / GAR Reader Service Account ──────────────────────────

resource "google_service_account" "k3s_sa" {
  project      = var.project_id
  account_id   = var.sa_name
  display_name = "K3s GCE Node & Artifact Registry Reader SA"
  description  = "Dedicated service account for K3s GCE instance to pull from GAR and push logs/metrics."
}

# Grant roles/artifactregistry.reader on project level
resource "google_project_iam_member" "k3s_sa_artifact_reader" {
  count   = var.manage_iam ? 1 : 0
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.k3s_sa.email}"
}

# Grant Cloud Logging and Monitoring for node observability
resource "google_project_iam_member" "k3s_sa_log_writer" {
  count   = var.manage_iam ? 1 : 0
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.k3s_sa.email}"
}

resource "google_project_iam_member" "k3s_sa_metric_writer" {
  count   = var.manage_iam ? 1 : 0
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.k3s_sa.email}"
}

# Allow the VM startup script (running as this SA) to generate its own JSON key
resource "google_service_account_iam_member" "k3s_sa_key_admin" {
  count              = var.manage_iam ? 1 : 0
  service_account_id = google_service_account.k3s_sa.name
  role               = "roles/iam.serviceAccountKeyAdmin"
  member             = "serviceAccount:${google_service_account.k3s_sa.email}"
}

# ── CI/CD Pipeline Service Account ───────────────────────────────────────────

resource "google_service_account" "cicd_sa" {
  project      = var.project_id
  account_id   = "ops-master-cicd"
  display_name = "CI/CD Pipeline Service Account (ops-master)"
  description  = "Service account used by GitHub Actions / CI pipeline to publish images to GAR."
}

resource "google_project_iam_member" "cicd_sa_artifact_writer" {
  count   = var.manage_iam ? 1 : 0
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.cicd_sa.email}"
}
