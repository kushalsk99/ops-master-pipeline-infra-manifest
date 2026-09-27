###############################################################################
# backend.tf
#
# Using the local backend so no GCP credentials or bucket are required.
# To migrate to S3-compatible object storage (MinIO, Cloudflare R2, etc.)
# just swap the backend block — no code changes needed elsewhere.
#
# Local backend stores state in ./terraform.tfstate on the machine that
# runs `terraform apply`. Commit the state file to a private git repo or
# move to a shared backend when team collaboration is needed.
###############################################################################

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4"
    }
  }

  # Local state — safe default for a single-operator K3s setup.
  # Uncomment the s3 block below (and remove this backend block) to use
  # S3-compatible storage such as MinIO or Cloudflare R2.
  backend "local" {
    path = "terraform.tfstate"
  }

  # ── Optional: S3-compatible backend ─────────────────────────────────────
  # backend "s3" {
  #   endpoint                    = "https://your-minio-or-r2-endpoint"
  #   bucket                      = "ops-master-tfstate"
  #   key                         = "infra-platform/state/terraform.tfstate"
  #   region                      = "us-east-1"   # dummy value required by S3 provider
  #   skip_credentials_validation = true
  #   skip_metadata_api_check     = true
  #   skip_region_validation      = true
  #   force_path_style            = true
  # }
}
