###############################################################################
# modules/artifact_registry/variables.tf
#
# Generic OCI-compatible container registry variables.
###############################################################################

variable "registry_url" {
  description = "Base URL of the container registry (e.g. ghcr.io, registry.example.com:5000, docker.io). Do NOT include a trailing slash."
  type        = string
}

variable "repository" {
  description = "Repository path within the registry (e.g. my-org/app-services-repo)."
  type        = string
}

variable "registry_username" {
  description = "Username for authenticating to the container registry. Used to generate the image pull secret reference output."
  type        = string
  default     = ""
}

variable "registry_password" {
  description = "Password or token for authenticating to the container registry. Store in a secrets manager."
  type        = string
  sensitive   = true
  default     = ""
}

variable "description" {
  description = "Human-readable description of the registry / repository (metadata only, not provisioned)."
  type        = string
  default     = "Container image registry for the ops-master pipeline."
}

variable "is_insecure" {
  description = "Set to true if the registry uses a self-signed certificate (adds --insecure flag hints to outputs)."
  type        = bool
  default     = false
}
