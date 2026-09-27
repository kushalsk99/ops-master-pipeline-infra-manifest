###############################################################################
# terraform.tfvars — GCE K3s & GitOps Platform
#
# Customize with your GCP project parameters before running terraform apply.
###############################################################################

# GCP Coordinates
project_id  = "ops-master-project"
region      = "us-central1"
zone        = "us-central1-a"
environment = "production"

# Compute Node Configuration
machine_type = "e2-standard-4"
k3s_version  = "v1.30.2+k3s1"

# GitOps & ArgoCD Root Application
gitops_repo_url        = "https://github.com/kushalsk99/ops-master-pipeline-argo-gitops.git"
gitops_path            = "."
gitops_target_revision = "HEAD"

# Admin Access Firewall (Restrict to your office or VPN CIDR for enhanced security)
admin_source_ranges = ["0.0.0.0/0"]