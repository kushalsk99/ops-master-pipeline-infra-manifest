###############################################################################
# modules/gke/main.tf
###############################################################################

resource "google_container_cluster" "primary" {
  provider = google-beta

  project  = var.project_id
  name     = var.cluster_name
  location = var.region

  # We manage node pools separately
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network
  subnetwork = var.subnetwork

  # Enable Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Private cluster
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "all"
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  # Enable network policy
  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
  }

  maintenance_policy {
    recurring_window {
      start_time = "2024-01-01T02:00:00Z"
      end_time   = "2024-01-01T06:00:00Z"
      recurrence = "FREQ=WEEKLY;BYDAY=SA,SU"
    }
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }
}

resource "google_container_node_pool" "primary_nodes" {
  provider = google-beta

  project    = var.project_id
  name       = var.node_pool_config.name
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.node_pool_config.min_count

  autoscaling {
    min_node_count = var.node_pool_config.min_count
    max_node_count = var.node_pool_config.max_count
  }

  node_config {
    machine_type = var.node_pool_config.machine_type
    disk_size_gb = var.node_pool_config.disk_size_gb
    disk_type    = "pd-ssd"
    image_type   = "COS_CONTAINERD"
    preemptible  = false

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }
}
