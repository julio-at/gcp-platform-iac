variable "project_id" {
  description = "GCP project ID for the cluster."
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE Autopilot cluster."
  type        = string
}

variable "location" {
  description = "Region (or zone) for the cluster. Autopilot typically uses a region, e.g. us-central1."
  type        = string
}

variable "network" {
  description = "VPC network name or self_link for the cluster."
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork name or self_link for the cluster."
  type        = string
}

variable "release_channel" {
  description = "Release channel for the cluster (RAPID, REGULAR, STABLE)."
  type        = string
  default     = "REGULAR"
}

variable "deletion_protection" {
  description = "Whether Terraform is prevented from deleting the cluster."
  type        = bool
  default     = false
}
