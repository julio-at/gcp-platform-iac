variable "project_id" {
  description = "GCP project ID where the repository will be created."
  type        = string
}

variable "location" {
  description = "Region for the Artifact Registry repository."
  type        = string
}

variable "repository_id" {
  description = "Repository ID (name) for the Artifact Registry repository."
  type        = string
}

variable "description" {
  description = "Description of the repository."
  type        = string
  default     = ""
}

variable "format" {
  description = "Repository format (e.g. DOCKER, MAVEN, NPM, PYTHON)."
  type        = string
  default     = "DOCKER"
}

variable "labels" {
  description = "Labels to apply to the repository."
  type        = map(string)
  default     = {}
}
