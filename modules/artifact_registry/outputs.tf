output "repository_id" {
  description = "Artifact Registry repository ID."
  value       = google_artifact_registry_repository.repo.repository_id
}

output "location" {
  description = "Repository location (region)."
  value       = google_artifact_registry_repository.repo.location
}

output "name" {
  description = "Full resource name of the repository."
  value       = google_artifact_registry_repository.repo.name
}

output "docker_repository_url" {
  description = "Base Docker repository URL (without image name or tag)."
  value       = "${google_artifact_registry_repository.repo.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}"
}
