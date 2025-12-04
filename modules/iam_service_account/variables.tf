variable "project_id" {
  description = "GCP project ID where the service account will be created."
  type        = string
}

variable "account_id" {
  description = "Service account ID (short name)."
  type        = string
}

variable "display_name" {
  description = "Display name for the service account."
  type        = string
}

variable "roles" {
  description = "List of IAM roles to attach to the service account at project level."
  type        = list(string)
  default     = []
}
