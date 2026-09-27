###############################################################################
# modules/gke/variables.tf
###############################################################################

variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "Region where the GKE cluster will be created."
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster."
  type        = string
}

variable "network" {
  description = "Name of the VPC network for the cluster."
  type        = string
}

variable "subnetwork" {
  description = "Name of the subnetwork for the cluster nodes."
  type        = string
}

variable "node_pool_config" {
  description = "Configuration object for the default node pool."
  type = object({
    name         = string
    machine_type = string
    min_count    = number
    max_count    = number
    disk_size_gb = number
  })
}
