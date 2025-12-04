output "email" {
  description = "Email address of the service account."
  value       = google_service_account.sa.email
}

output "name" {
  description = "Resource name of the service account."
  value       = google_service_account.sa.name
}
