# GCP Platform IaC – Lab & Prod

Infrastructure-as-Code (IaC) baseline for GCP using Terraform.  
It creates, per environment:

- Custom VPC network and subnetwork.
- GKE Autopilot cluster.
- Artifact Registry Docker repository.
- Generic IAM service account for workloads and CI/CD.

This repo is intentionally small and opinionated so you can extend it.
