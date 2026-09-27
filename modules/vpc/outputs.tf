###############################################################################
# modules/vpc/outputs.tf
###############################################################################

output "network_name" {
  description = "The name of the VPC network."
  value       = google_compute_network.vpc.name
}

output "network_self_link" {
  description = "The URI (self_link) of the VPC network."
  value       = google_compute_network.vpc.self_link
}

output "subnet_names" {
  description = "Names of all created subnets."
  value       = [for s in google_compute_subnetwork.subnets : s.name]
}

output "subnet_self_links" {
  description = "Self-links of all created subnets."
  value       = [for s in google_compute_subnetwork.subnets : s.self_link]
}
