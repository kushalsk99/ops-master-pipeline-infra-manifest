###############################################################################
# modules/k3s/main.tf
#
# Bootstraps a K3s cluster on a PRE-PROVISIONED node via SSH.
# No cloud provider resources are created here — the node (bare-metal,
# VPS, VM, etc.) must already exist and be reachable at var.node_ip:22.
#
# What this module does:
#   1. Connects to the node over SSH via remote-exec.
#   2. Installs K3s using the official get.k3s.io script.
#   3. Waits until the node is Ready.
#   4. Fetches /etc/rancher/k3s/k3s.yaml via local-exec, patches the
#      server URL to use the public IP, and saves it locally.
###############################################################################

terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2"
    }
  }
}

resource "null_resource" "k3s_install" {
  triggers = {
    node_ip     = var.node_ip
    k3s_version = var.k3s_version
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.ssh_private_key_path)
    host        = var.node_ip
    timeout     = "5m"
  }

  provisioner "remote-exec" {
    inline = [
      "set -euo pipefail",
      "echo '[K3s] Installing K3s ${var.k3s_version} on ${var.node_ip}...'",
      "curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION='${var.k3s_version}' INSTALL_K3S_EXEC='server --disable traefik --tls-san ${var.node_ip}' sh -",
      "echo '[K3s] Waiting for node to become Ready...'",
      "until sudo k3s kubectl get node 2>/dev/null | grep -q ' Ready'; do sleep 5; done",
      "echo '[K3s] Node is Ready.'",
    ]
  }

  provisioner "local-exec" {
    command = <<-EOT
      set -euo pipefail
      mkdir -p ${var.kubeconfig_output_dir}
      ssh -o StrictHostKeyChecking=no \
          -i ${var.ssh_private_key_path} \
          ${var.ssh_user}@${var.node_ip} \
          "sudo cat /etc/rancher/k3s/k3s.yaml" \
        | sed 's|https://127.0.0.1:6443|https://${var.node_ip}:6443|g' \
        > ${var.kubeconfig_output_dir}/${var.cluster_name}-kubeconfig.yaml
      chmod 600 ${var.kubeconfig_output_dir}/${var.cluster_name}-kubeconfig.yaml
      echo "[K3s] kubeconfig saved → ${var.kubeconfig_output_dir}/${var.cluster_name}-kubeconfig.yaml"
    EOT
  }
}
