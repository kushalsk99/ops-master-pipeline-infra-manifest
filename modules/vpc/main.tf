###############################################################################
# modules/vpc/main.tf
#
# Custom VPC, Subnets, Cloud NAT, and comprehensive Firewall Rules for
# K3s, Linkerd Service Mesh, and external HTTP/HTTPS traffic.
###############################################################################

# ── VPC Network ──────────────────────────────────────────────────────────────

resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# ── Subnetworks ──────────────────────────────────────────────────────────────

resource "google_compute_subnetwork" "subnets" {
  for_each = { for s in var.subnets : s.name => s }

  project                  = var.project_id
  name                     = each.value.name
  ip_cidr_range            = each.value.ip_cidr_range
  region                   = each.value.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# ── Cloud Router & Cloud NAT ─────────────────────────────────────────────────
# Ensures K3s VM can pull OS packages, container images, and GitHub manifests

resource "google_compute_router" "router" {
  project = var.project_id
  name    = "${var.network_name}-router"
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  project                            = var.project_id
  name                               = "${var.network_name}-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# ── Firewall Rules ───────────────────────────────────────────────────────────

# 1. Internal VPC Traffic (intra-subnet communications)
resource "google_compute_firewall" "allow_internal" {
  project     = var.project_id
  name        = "${var.network_name}-allow-internal"
  network     = google_compute_network.vpc.name
  description = "Allow internal traffic across subnets"

  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = [for s in var.subnets : s.ip_cidr_range]
}

# 2. Inbound HTTP / HTTPS Traffic
resource "google_compute_firewall" "allow_http_https" {
  project     = var.project_id
  name        = "${var.network_name}-allow-http-https"
  network     = google_compute_network.vpc.name
  description = "Allow inbound HTTP (80) and HTTPS (443) traffic to the K3s node"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["k3s-node", "http-server", "https-server"]
}

# 3. Linkerd Service Mesh Proxy Communication
#    - Port 4140: Outbound linkerd-proxy
#    - Port 4143: Inbound linkerd-proxy
#    - Port 4191: Proxy admin / metrics endpoint
#    - Port 8080: Control plane controller / metrics
#    - Port 8443: Control plane identity & admission webhook
resource "google_compute_firewall" "allow_linkerd" {
  project     = var.project_id
  name        = "${var.network_name}-allow-linkerd"
  network     = google_compute_network.vpc.name
  description = "Allow Linkerd sidecar proxy and control plane mesh traffic"

  allow {
    protocol = "tcp"
    ports    = ["4140", "4143", "4191", "8080", "8443"]
  }

  source_ranges = concat(
    [for s in var.subnets : s.ip_cidr_range],
    ["10.42.0.0/16", "10.43.0.0/16"] # Default K3s Pod and Service CIDRs
  )
  target_tags = ["k3s-node"]
}

# 4. K3s Kubernetes API Server (port 6443)
resource "google_compute_firewall" "allow_k3s_api" {
  project     = var.project_id
  name        = "${var.network_name}-allow-k3s-api"
  network     = google_compute_network.vpc.name
  description = "Allow inbound K3s API server traffic on port 6443"

  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }

  source_ranges = var.admin_source_ranges
  target_tags   = ["k3s-node"]
}

# 5. SSH Management Access (including GCP Cloud IAP)
resource "google_compute_firewall" "allow_ssh" {
  project     = var.project_id
  name        = "${var.network_name}-allow-ssh"
  network     = google_compute_network.vpc.name
  description = "Allow SSH access from admin ranges and Google Cloud IAP"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = distinct(concat(["35.235.240.0/20"], var.admin_source_ranges))
  target_tags   = ["k3s-node"]
}

# 6. GCP Load Balancer Health Checks
resource "google_compute_firewall" "allow_health_checks" {
  project     = var.project_id
  name        = "${var.network_name}-allow-health-checks"
  network     = google_compute_network.vpc.name
  description = "Allow Google Cloud Load Balancer health check probes"

  allow {
    protocol = "tcp"
  }

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = ["k3s-node"]
}
