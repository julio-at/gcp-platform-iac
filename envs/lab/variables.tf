variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "Default region for resources."
  type        = string
  default     = "us-central1"
}

variable "network_name" {
  description = "VPC network name."
  type        = string
  default     = "lab-vpc"
}

variable "subnetwork_name" {
  description = "Subnetwork name."
  type        = string
  default     = "lab-subnet-us-central1"
}

variable "subnetwork_cidr" {
  description = "CIDR range for the subnetwork."
  type        = string
  default     = "10.10.0.0/24"
}

variable "cluster_name" {
  description = "GKE Autopilot cluster name."
  type        = string
  default     = "lab-autopilot"
}

variable "artifact_repo_id" {
  description = "Artifact Registry repository ID for Docker images."
  type        = string
  default     = "lab-docker"
}

variable "gke_sa_name" {
  description = "Service account ID for general GKE workloads/CI (optional)."
  type        = string
  default     = "lab-gke-workload"
}
