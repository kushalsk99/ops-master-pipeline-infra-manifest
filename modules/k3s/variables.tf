###############################################################################
# modules/k3s/variables.tf
###############################################################################

variable "cluster_name" {
  description = "Logical name for this K3s cluster (used to name the saved kubeconfig file)."
  type        = string
  default     = "k3s-cluster"
}

variable "k3s_version" {
  description = "K3s release version to install (see https://github.com/k3s-io/k3s/releases)."
  type        = string
  default     = "v1.30.2+k3s1"
}

variable "node_ip" {
  description = "Public IP address (or hostname) of the pre-provisioned K3s server node. Must be reachable from the Terraform host on port 22."
  type        = string
}

variable "ssh_user" {
  description = "SSH username for connecting to the K3s node."
  type        = string
  default     = "ubuntu"
}

variable "ssh_private_key_path" {
  description = "Absolute local path to the SSH private key for the K3s node."
  type        = string
  sensitive   = true
}

variable "kubeconfig_output_dir" {
  description = "Local directory where the fetched kubeconfig will be saved."
  type        = string
  default     = "~/.kube"
}
