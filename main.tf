###############################################################################
# Root main.tf — GCE K3s & GitOps Platform
#
# Orchestrates VPC networking, Artifact Registry, IAM privileges,
# and GCE K3s deployment bootstrapped with GAR secrets, ArgoCD & Linkerd support.
###############################################################################

terraform {
  required_version = ">= 1.6.0"

  backend "gcs" {
    bucket = "ops-master-tf-state-bucket"
    prefix = "terraform/state"
  }

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
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

# ---------------------------------------------------------------------------
# VPC Networking & Firewalls
# ---------------------------------------------------------------------------
module "vpc" {
  source = "./modules/vpc"

  project_id   = var.project_id
  region       = var.region
  network_name = "app-vpc-${var.environment}"
  subnets = [
    {
      name          = "k3s-subnet-${var.environment}"
      ip_cidr_range = "10.0.0.0/16"
      region        = var.region
    }
  ]
  admin_source_ranges = var.admin_source_ranges
}

# ---------------------------------------------------------------------------
# Google Artifact Registry (GAR)
# ---------------------------------------------------------------------------
module "artifact_registry" {
  source = "./modules/artifact_registry"

  project_id        = var.project_id
  region            = var.region
  repository_id     = var.artifact_repo_name
  create_repository = var.create_artifact_repo
  description       = "Docker container image registry for ops-master GitOps pipeline (${var.environment})."
}

# ---------------------------------------------------------------------------
# IAM & Dedicated Service Accounts
# ---------------------------------------------------------------------------
module "iam" {
  source = "./modules/iam"

  project_id = var.project_id
  sa_name    = "k3s-gar-reader-${var.environment}"
  manage_iam = var.manage_iam
}

# ---------------------------------------------------------------------------
# K3s GCE Instance & Startup Bootstrapping
# ---------------------------------------------------------------------------
module "k3s" {
  source = "./modules/k3s"

  project_id             = var.project_id
  zone                   = var.zone
  cluster_name           = "k3s-server-${var.environment}"
  machine_type           = var.machine_type
  subnetwork_id          = module.vpc.subnet_ids["k3s-subnet-${var.environment}"]
  service_account_email  = module.iam.service_account_email
  k3s_version            = var.k3s_version
  registry_host          = module.artifact_registry.registry_host
  gitops_repo_url        = var.gitops_repo_url
  gitops_path            = var.gitops_path
  gitops_target_revision = var.gitops_target_revision

  depends_on = [
    module.vpc,
    module.iam,
    module.artifact_registry
  ]
}