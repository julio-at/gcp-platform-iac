terraform {
  backend "gcs" {
    # IMPORTANT:
    # 1) Create this bucket first, for example:
    #      gsutil mb -l us-central1 gs://my-tf-state-bucket
    # 2) Replace the bucket name below with yours.
    bucket = "tf_state_monaguillo"
    prefix = "gcp-platform-iac/lab"
  }
}
