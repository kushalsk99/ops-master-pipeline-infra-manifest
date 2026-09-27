###############################################################################
# Root variables.tf — K3s-native infrastructure
# All GCP-specific variables removed.
###############################################################################

# ── Environment ───────────────────────────────────────────────────────────────

variable "environment" {
  description = "Deployment environment label (e.g. production, staging, dev). Used to namespace resource names."
  type        = string
  default     = "production"
}

# ── K3s Node ──────────────────────────────────────────────────────────────────

variable "node_ip" {
  description = "Public IP address (or hostname) of the pre-provisioned K3s server node. This node must be reachable via SSH before running terraform apply."
  type        = string
}

variable "k3s_version" {
  description = "K3s release version to install (see https://github.com/k3s-io/k3s/releases)."
  type        = string
  default     = "v1.30.2+k3s1"
}

# ── SSH ───────────────────────────────────────────────────────────────────────

variable "ssh_user" {
  description = "SSH username for connecting to the K3s node."
  type        = string
  default     = "ubuntu"
}

variable "ssh_private_key_path" {
  description = "Absolute local path to the SSH private key used to access the K3s node."
  type        = string
  sensitive   = true
}

variable "kubeconfig_output_dir" {
  description = "Local directory where the fetched kubeconfig will be saved after K3s bootstrap."
  type        = string
  default     = "~/.kube"
}

# ── Container Registry ────────────────────────────────────────────────────────

variable "registry_url" {
  description = "Base URL of the OCI container registry (e.g. ghcr.io, docker.io, registry.example.com:5000)."
  type        = string
  default     = "ghcr.io"
}

variable "registry_username" {
  description = "Username for authenticating to the container registry."
  type        = string
  default     = ""
}

variable "registry_password" {
  description = "Password or token for authenticating to the container registry. Use TF_VAR_registry_password or a secrets manager."
  type        = string
  sensitive   = true
  default     = ""
}

variable "registry_is_insecure" {
  description = "Set to true if the registry endpoint uses a self-signed certificate."
  type        = bool
  default     = false
}

# ── PostgreSQL (in-cluster / self-hosted) ─────────────────────────────────────

variable "pg_host" {
  description = "PostgreSQL hostname or Kubernetes Service name / ClusterIP. For in-cluster deployments this is typically the Helm release Service name (e.g. postgres.default.svc.cluster.local)."
  type        = string
  default     = "postgres.default.svc.cluster.local"
}

variable "pg_port" {
  description = "PostgreSQL port."
  type        = number
  default     = 5432
}

variable "pg_database" {
  description = "PostgreSQL database name."
  type        = string
  default     = "ops_master"
}

variable "pg_username" {
  description = "PostgreSQL username."
  type        = string
  default     = "ops_user"
}

variable "pg_password" {
  description = "PostgreSQL password. Use TF_VAR_pg_password env var or a secrets manager — do not commit plaintext."
  type        = string
  sensitive   = true
}

variable "pg_ssl_mode" {
  description = "PostgreSQL SSL mode (disable | require | verify-ca | verify-full)."
  type        = string
  default     = "disable"
}
