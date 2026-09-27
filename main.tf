###############################################################################
# Root main.tf — K3s-native infrastructure
#
# No cloud provider required. Modules use only null/local providers.
# K3s node is assumed to be pre-provisioned (bare-metal, VM, VPS, etc.)
# and reachable via SSH at var.node_ip.
###############################################################################

# ---------------------------------------------------------------------------
# K3s Cluster
# Bootstrap K3s on a pre-provisioned node via SSH.
# ---------------------------------------------------------------------------
module "k3s" {
  source = "./modules/k3s"

  cluster_name          = "k3s-cluster-${var.environment}"
  k3s_version           = var.k3s_version
  node_ip               = var.node_ip
  ssh_user              = var.ssh_user
  ssh_private_key_path  = var.ssh_private_key_path
  kubeconfig_output_dir = var.kubeconfig_output_dir
}

# ---------------------------------------------------------------------------
# Container Registry (generic OCI)
# Accepts any registry endpoint: GHCR, Docker Hub, self-hosted, etc.
# ---------------------------------------------------------------------------
module "artifact_registry" {
  source = "./modules/artifact_registry"

  registry_url      = var.registry_url
  repository        = "app-services-repo-${var.environment}"
  registry_username = var.registry_username
  registry_password = var.registry_password
  description       = "Container image registry for the ops-master pipeline (${var.environment})."
  is_insecure       = var.registry_is_insecure
}

# ---------------------------------------------------------------------------
# Database — generic PostgreSQL endpoint
#
# Deploy PostgreSQL inside K3s using the Bitnami Helm chart:
#   helm repo add bitnami https://charts.bitnami.com/bitnami
#   helm install postgres bitnami/postgresql \
#     --set auth.username=ops_user \
#     --set auth.password=<password> \
#     --set auth.database=ops_master
#
# Then set var.pg_host to the Service ClusterIP or LoadBalancer address.
# ---------------------------------------------------------------------------
module "database" {
  source = "./modules/database"

  pg_host     = var.pg_host
  pg_port     = var.pg_port
  pg_database = var.pg_database
  pg_username = var.pg_username
  pg_password = var.pg_password
  pg_ssl_mode = var.pg_ssl_mode
}