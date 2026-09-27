###############################################################################
# terraform.tfvars — GCE K3s & GitOps Platform
###############################################################################

# GCP Coordinates
project_id  = "projects-buildcwnelson-507509"
region      = "us-central1"
zone        = "us-central1-a"
environment = "production"

# Artifact Registry (Using your existing GCP Docker repository)
artifact_repo_name   = "opsmaster-pipeline"
create_artifact_repo = false

# IAM Policy Bindings
# Set to true only if the GitHub Actions Service Account has Project IAM Admin role
manage_iam = false

# Compute Node Configuration
machine_type = "e2-standard-4"
k3s_version  = "v1.30.2+k3s1"

# GitOps & ArgoCD Root Application
gitops_repo_url        = "https://github.com/kushalsk99/ops-master-pipeline-argo-gitops.git"
gitops_path            = "."
gitops_target_revision = "HEAD"

# Admin Access Firewall (Restrict to your office or VPN CIDR for enhanced security)
admin_source_ranges = ["0.0.0.0/0"]