terraform {
  backend "gcs" {
    # IMPORTANT:
    # 1) Create this bucket first, for example:
    #      gsutil mb -l us-central1 gs://my-tf-state-bucket
    # 2) Replace the bucket name below with yours.
    bucket = "CHANGE_ME_TF_STATE_BUCKET"
    prefix = "gcp-platform-iac/lab"
  }
}
