###############################################################################
# modules/k3s/main.tf
#
# Provisions a Google Compute Engine (GCE) VM instance running K3s,
# configured with a startup script that injects GAR pull credentials
# and bootstraps ArgoCD and Linkerd-compatible GitOps root application.
###############################################################################

resource "google_compute_instance" "k3s_server" {
  name         = var.cluster_name
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["k3s-node", "http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 50
      type  = "pd-ssd"
    }
  }

  network_interface {
    subnetwork = var.subnetwork_id

    # Allocate ephemeral public IPv4
    access_config {
      network_tier = "PREMIUM"
    }
  }

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  metadata_startup_script = templatefile("${path.module}/templates/startup.sh.tpl", {
    k3s_version            = var.k3s_version
    gar_reader_sa_email    = var.service_account_email
    registry_host          = var.registry_host
    gitops_repo_url        = var.gitops_repo_url
    gitops_path            = var.gitops_path
    gitops_target_revision = var.gitops_target_revision
  })

  labels = {
    managed-by = "terraform"
    role       = "k3s-server"
  }
}
