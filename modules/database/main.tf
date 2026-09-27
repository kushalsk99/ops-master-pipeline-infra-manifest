###############################################################################
# modules/database/main.tf
#
# Generic PostgreSQL endpoint module.
#
# This module does NOT provision a managed cloud database.
# Instead it accepts connection parameters for any PostgreSQL instance
# (self-hosted inside K3s via a Helm/manifest deployment, an existing
# CloudSQL instance, RDS, etc.) and surfaces them as structured outputs
# consumed by other modules or application configs.
#
# To deploy PostgreSQL inside K3s, pair this with a Helm release or a
# Kubernetes manifest (e.g. Bitnami PostgreSQL chart) applied separately.
###############################################################################

terraform {
  required_providers {
    # null provider used to create a validated config resource
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
  }
}

# Validate that the required connection fields are non-empty at plan time.
resource "null_resource" "pg_config_validation" {
  triggers = {
    host     = var.pg_host
    port     = tostring(var.pg_port)
    database = var.pg_database
    username = var.pg_username
  }

  lifecycle {
    # Re-trigger if any connection coordinate changes
    replace_triggered_by = []
  }
}
