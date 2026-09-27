###############################################################################
# backend.tf — Terraform & Provider Configurations
###############################################################################

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }

  # Local state default for single-operator deployments.
  # Swap to GCS backend when running in team/CI environments.
  backend "local" {
    path = "terraform.tfstate"
  }

  # ── Remote GCS Backend (Optional) ──────────────────────────────────────────
  # backend "gcs" {
  #   bucket = "YOUR_GCP_PROJECT_ID-tfstate"
  #   prefix = "infra-platform/state"
  # }
}
