module "network" {
  source          = "../../modules/network"
  project_id      = var.project_id
  region          = var.region
  network_name    = var.network_name
  subnetwork_name = var.subnetwork_name
  subnetwork_cidr = var.subnetwork_cidr
}

module "gke_sa" {
  source       = "../../modules/iam_service_account"
  project_id   = var.project_id
  account_id   = var.gke_sa_name
  display_name = "Prod GKE workloads"
  roles = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/artifactregistry.reader",
  ]
}

module "gke_autopilot" {
  source       = "../../modules/gke_autopilot"
  project_id   = var.project_id
  location     = var.region
  cluster_name = var.cluster_name
  network      = module.network.network_name
  subnetwork   = module.network.subnetwork_name
}

module "artifact_registry" {
  source        = "../../modules/artifact_registry"
  project_id    = var.project_id
  location      = var.region
  repository_id = var.artifact_repo_id
  description   = "Prod Docker images"
  format        = "DOCKER"
  labels = {
    environment = "prod"
  }
}
