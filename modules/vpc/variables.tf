###############################################################################
# modules/vpc/variables.tf
###############################################################################

variable "project_id" {
  description = "GCP Project ID."
  type        = string
}

variable "region" {
  description = "GCP Region for VPC resources."
  type        = string
}

variable "network_name" {
  description = "Name of the VPC network."
  type        = string
}

variable "subnets" {
  description = "List of subnets to create."
  type = list(object({
    name          = string
    ip_cidr_range = string
    region        = string
  }))
}

variable "admin_source_ranges" {
  description = "Source IP CIDR ranges allowed to access administrative ports (K3s API, SSH)."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
