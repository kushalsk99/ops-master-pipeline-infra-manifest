###############################################################################
# modules/vpc/variables.tf
###############################################################################

variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "Default region for resources."
  type        = string
}

variable "network_name" {
  description = "Name of the VPC network."
  type        = string
}

variable "subnets" {
  description = "List of subnet configurations."
  type = list(object({
    name          = string
    ip_cidr_range = string
    region        = string
  }))
}
