variable "project_id" {
  description = "GCP project ID where the network will be created."
  type        = string
}

variable "network_name" {
  description = "Name of the VPC network."
  type        = string
}

variable "subnetwork_name" {
  description = "Name of the primary subnetwork."
  type        = string
}

variable "region" {
  description = "Region for the subnetwork."
  type        = string
}

variable "subnetwork_cidr" {
  description = "CIDR range for the subnetwork."
  type        = string
}
