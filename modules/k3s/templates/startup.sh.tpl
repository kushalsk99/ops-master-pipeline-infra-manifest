#!/usr/bin/env bash
###############################################################################
# startup.sh.tpl — GCE Instance Startup Script for K3s, GAR & ArgoCD
#
# Execution log: /var/log/k3s-bootstrap.log
###############################################################################
set -euo pipefail
exec > >(tee -a /var/log/k3s-bootstrap.log) 2>&1

echo "=========================================================="
echo "Starting K3s & GitOps Provisioning at $(date -u)"
echo "=========================================================="

export DEBIAN_FRONTEND=noninteractive
export HOME=/root

# ── 1. OS Preparation & Package Installation ──────────────────────────────────
echo "[1/6] Installing OS prerequisites..."
apt-get update -y
apt-get install -y curl ca-certificates jq gnupg apt-transport-https

# Detect External IP from GCE metadata server
EXTERNAL_IP=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip || hostname -I | awk '{print $1}')
echo "Detected GCE External IP: $${EXTERNAL_IP}"

# ── 2. Install K3s Server ────────────────────────────────────────────────────
echo "[2/6] Installing K3s ${k3s_version}..."
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="${k3s_version}" INSTALL_K3S_EXEC="server --tls-san $${EXTERNAL_IP} --write-kubeconfig-mode 644 --disable traefik" sh -

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# ── 3. Wait for K3s API & Node Readiness ─────────────────────────────────────
echo "[3/6] Waiting for K3s API server and node to become Ready..."
until /usr/local/bin/kubectl get nodes --no-headers 2>/dev/null | grep -q ' Ready'; do
  echo "Waiting for k3s node to report Ready state..."
  sleep 4
done
echo "K3s node is Ready."

# ── 4. Generate JSON Key for SA & Inject Docker Secret ────────────────────────
echo "[4/6] Generating JSON key for GAR reader Service Account: ${gar_reader_sa_email}..."
KEY_FILE="/tmp/gar-sa-key.json"

# Attempt to generate SA key via gcloud using the VM's attached identity
if gcloud iam service-accounts keys create "$${KEY_FILE}" --iam-account="${gar_reader_sa_email}" 2>/dev/null; then
  echo "Injecting gar-reader-secret into default, web-service-dev, and web-service-prod namespaces..."
  for NS in default web-service-dev web-service-prod; do
    echo "Setting up GAR pull secret in namespace: $NS"
    /usr/local/bin/kubectl create namespace "$NS" --dry-run=client -o yaml | /usr/local/bin/kubectl apply -f -
    /usr/local/bin/kubectl create secret docker-registry gar-reader-secret \
      --namespace="$NS" \
      --docker-server="${registry_host}" \
      --docker-username=_json_key \
      --docker-password="$(cat "$${KEY_FILE}")" \
      --dry-run=client -o yaml | /usr/local/bin/kubectl apply -f -
    /usr/local/bin/kubectl patch serviceaccount default \
      --namespace="$NS" \
      -p '{"imagePullSecrets": [{"name": "gar-reader-secret"}]}' || true
  done
  shred -u "$${KEY_FILE}" 2>/dev/null || rm -f "$${KEY_FILE}"
  echo "gar-reader-secret injected successfully and local key file destroyed."
else
  echo "[WARNING] Could not generate JSON key for ${gar_reader_sa_email} (missing Service Account Key Admin role)."
  echo "[INFO] Creating target namespaces anyway..."
  for NS in default web-service-dev web-service-prod; do
    /usr/local/bin/kubectl create namespace "$NS" --dry-run=client -o yaml | /usr/local/bin/kubectl apply -f -
  done
fi

# ── 5. ArgoCD Bootstrapping ──────────────────────────────────────────────────
echo "[5/6] Bootstrapping ArgoCD..."

# Create argocd namespace
/usr/local/bin/kubectl create namespace argocd --dry-run=client -o yaml | /usr/local/bin/kubectl apply -f -

# Install ArgoCD Core Manifests
echo "Applying ArgoCD official manifests with server-side apply..."
/usr/local/bin/kubectl apply --server-side --force-conflicts -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Install ArgoCD CLI binary
echo "Downloading ArgoCD CLI..."
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd

# Wait for ArgoCD Server deployment to be ready
echo "Waiting for ArgoCD server deployment to become available..."
/usr/local/bin/kubectl wait --namespace argocd --for=condition=available deployment/argocd-server --timeout=360s

# ── 6. Apply Root ArgoCD Application (GitOps) ────────────────────────────────
echo "[6/6] Deploying Root ArgoCD Application pointing to ${gitops_repo_url}..."

cat <<'EOF' > /tmp/root-application.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: root-application
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    repoURL: '${gitops_repo_url}'
    targetRevision: '${gitops_target_revision}'
    path: '${gitops_path}'
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
EOF

/usr/local/bin/kubectl apply -f /tmp/root-application.yaml
rm -f /tmp/root-application.yaml

echo "=========================================================="
echo "K3s, GAR Secret & ArgoCD Root App Bootstrap Complete!"
echo "Finished at $(date -u)"
echo "=========================================================="
