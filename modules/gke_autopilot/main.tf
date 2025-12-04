resource "google_container_cluster" "autopilot" {
  name     = var.cluster_name
  location = var.location
  project  = var.project_id

  enable_autopilot    = true
  deletion_protection = var.deletion_protection

  network    = var.network
  subnetwork = var.subnetwork

  release_channel {
    channel = var.release_channel
  }
}
