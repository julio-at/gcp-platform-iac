output "name" {
  description = "Name of the Autopilot cluster."
  value       = google_container_cluster.autopilot.name
}

output "location" {
  description = "Location of the Autopilot cluster."
  value       = google_container_cluster.autopilot.location
}

output "endpoint" {
  description = "GKE control plane endpoint."
  value       = google_container_cluster.autopilot.endpoint
}

output "id" {
  description = "Cluster ID."
  value       = google_container_cluster.autopilot.id
}
