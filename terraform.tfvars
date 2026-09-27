###############################################################################
# terraform.tfvars — K3s-native infrastructure
#
# Replace every <REPLACE> value with your actual settings.
# For sensitive values (pg_password, registry_password, ssh_private_key_path)
# prefer environment variables:
#   export TF_VAR_pg_password="..."
#   export TF_VAR_registry_password="..."
#   export TF_VAR_ssh_private_key_path="..."
###############################################################################

# Deployment environment
environment = "production"

# K3s node — must be reachable via SSH before terraform apply
node_ip     = "1.2.3.4"             # <REPLACE> with your node's public IP

# K3s version
k3s_version = "v1.30.2+k3s1"

# SSH access
ssh_user             = "ubuntu"     # <REPLACE> if your node uses a different user
ssh_private_key_path = "~/.ssh/id_rsa"  # <REPLACE>
kubeconfig_output_dir = "~/.kube"

# Container registry (GHCR example — swap for docker.io or self-hosted)
registry_url          = "ghcr.io"
registry_username     = ""          # <REPLACE>
# registry_password   = ""         # Set via TF_VAR_registry_password
registry_is_insecure  = false

# PostgreSQL — in-cluster via Bitnami Helm chart
pg_host     = "postgres.default.svc.cluster.local"
pg_port     = 5432
pg_database = "ops_master"
pg_username = "ops_user"
# pg_password = ""                  # Set via TF_VAR_pg_password
pg_ssl_mode = "disable"