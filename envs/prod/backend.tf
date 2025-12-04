terraform {
  backend "gcs" {
    bucket = "CHANGE_ME_TF_STATE_BUCKET"
    prefix = "gcp-platform-iac/prod"
  }
}
