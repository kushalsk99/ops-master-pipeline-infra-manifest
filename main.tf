###############################################################################
# Root main.tf
# Orchestrates all infrastructure modules for the ops-master pipeline.
###############################################################################

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

# ---------------------------------------------------------------------------
# VPC
# ---------------------------------------------------------------------------
module "vpc" {
  source = "./modules/vpc"

  project_id   = var.project_id
  region       = var.region
  network_name = "app-vpc-${var.environment}"
  subnets = [
    {
      name          = "app-subnet-${var.environment}"
      ip_cidr_range = "10.0.0.0/16"
      region        = var.region
    }
  ]
}

# ---------------------------------------------------------------------------
# GKE
# ---------------------------------------------------------------------------
module "gke" {
  source = "./modules/gke"

  project_id   = var.project_id
  region       = var.region
  cluster_name = "gke-autopilot-cluster-${var.environment}"
  network      = module.vpc.network_name
  subnetwork   = module.vpc.subnet_names[0]
  node_pool_config = {
    name         = "default-pool"
    machine_type = "e2-standard-4"
    min_count    = 1
    max_count    = 5
    disk_size_gb = 100
  }

  depends_on = [module.vpc]
}

# ---------------------------------------------------------------------------
# Artifact Registry
# ---------------------------------------------------------------------------
module "artifact_registry" {
  source = "./modules/artifact_registry"

  project_id    = var.project_id
  region        = var.region
  repository_id = "app-services-repo-${var.environment}"
  description   = "Container image registry for the ops-master pipeline (${var.environment})."
  format        = "DOCKER"
}

# ---------------------------------------------------------------------------
# Database (Cloud SQL)
# ---------------------------------------------------------------------------
module "database" {
  source = "./modules/database"

  project_id          = var.project_id
  region              = var.region
  instance_name       = "app-postgres-db-${var.environment}"
  database_version    = "POSTGRES_15"
  tier                = "db-f1-micro"
  network             = module.vpc.network_self_link
  deletion_protection = false

  depends_on = [module.vpc]
}

# ---------------------------------------------------------------------------
# IAM
# ---------------------------------------------------------------------------
module "iam" {
  source = "./modules/iam"

  project_id             = var.project_id
  gke_sa_name            = "ops-master-gke-sa-${var.environment}"
  artifact_registry_repo = module.artifact_registry.repository_id
  workload_identity_pool = module.gke.workload_identity_pool

  depends_on = [module.gke, module.artifact_registry]
}