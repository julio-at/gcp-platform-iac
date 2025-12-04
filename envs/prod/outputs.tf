output "network_name" {
  description = "VPC network name."
  value       = module.network.network_name
}

output "subnetwork_name" {
  description = "Subnetwork name."
  value       = module.network.subnetwork_name
}

output "gke_cluster_name" {
  description = "Name of the GKE Autopilot cluster."
  value       = module.gke_autopilot.name
}

output "gke_location" {
  description = "Location of the GKE Autopilot cluster."
  value       = module.gke_autopilot.location
}

output "artifact_registry_repo" {
  description = "Artifact Registry Docker repository URL base."
  value       = module.artifact_registry.docker_repository_url
}

output "gke_workload_sa_email" {
  description = "Email of the prod workload service account."
  value       = module.gke_sa.email
}
