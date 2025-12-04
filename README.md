# GCP Platform IaC (Lab / PoC)

Infrastructure-as-Code (IaC) baseline for Google Cloud Platform using Terraform.

This repository creates, per environment:

- A **custom VPC** and subnetwork.
- A **GKE Autopilot** cluster.
- An **Artifact Registry** Docker repository.
- A **service account** for workloads / CI with basic logging & metrics roles.

The goal is to have a **repeatable lab / PoC platform** that can be torn down and recreated in minutes.

> **Audience:**  
> - Infrastructure / DevOps / SRE / Platform engineers who already know Terraform basics.  
> - People who want a clean starting point for GCP labs or small prototypes (not a fully hardened production setup).

---

## Repository layout

```text
gcp-platform-iac/
├── README.md
├── envs/
│   ├── lab/
│   │   ├── backend.tf              # Remote state (GCS bucket)
│   │   ├── main.tf                 # Wires modules together
│   │   ├── providers.tf            # Google provider for this env
│   │   ├── terraform.tfvars.example
│   │   ├── variables.tf
│   │   └── versions.tf
│   └── prod/                       # Same pattern, for future use
│       ├── backend.tf
│       ├── main.tf
│       ├── providers.tf
│       ├── terraform.tfvars.example
│       ├── variables.tf
│       └── versions.tf
└── modules/
    ├── artifact_registry/          # Artifact Registry Docker repo
    ├── gke_autopilot/              # GKE Autopilot cluster
    ├── iam_service_account/        # Generic workload/CI service account
    └── network/                    # VPC + subnetwork
```

---

## Prerequisites

Assumptions:

- You already have:
  - `gcloud` (Google Cloud SDK) installed and authenticated.
  - Terraform `>= 1.5`.
- You have a **GCP billing account** available.
- You are comfortable with basic CLI usage.

---

## 1. Create a project and set it as default

Choose a unique project ID and create the project:

```bash
export PROJECT_ID="CHANGE_ME_PROJECT_ID"
gcloud projects create "$PROJECT_ID" --name="GCP Lab Platform"
```

Link it to your billing account (replace `CHANGE_ME_BILLING_ACCOUNT`):

```bash
gcloud beta billing projects link "$PROJECT_ID"   --billing-account="CHANGE_ME_BILLING_ACCOUNT"
```

Set it as the active project:

```bash
gcloud config set project "$PROJECT_ID"
```

You can verify:

```bash
gcloud config get-value project
```

---

## 2. Enable required APIs

From the same shell, enable the APIs used by this Terraform stack:

```bash
gcloud services enable   compute.googleapis.com   container.googleapis.com   artifactregistry.googleapis.com   iam.googleapis.com
```

If you later add other services (Cloud Run, Cloud SQL, etc.) you’ll have to enable their APIs too.

---

## 3. Prepare the Terraform remote state bucket

Terraform state for each environment is stored in **GCS**.

1. Create the bucket (pick a unique name):

   ```bash
   export TF_STATE_BUCKET="CHANGE_ME_TF_STATE_BUCKET"
   gsutil mb -l us-central1 "gs://${TF_STATE_BUCKET}"
   ```

2. Edit `envs/lab/backend.tf` and set the bucket name:

   ```hcl
   terraform {
     backend "gcs" {
       bucket = "CHANGE_ME_TF_STATE_BUCKET"  # <--- put your bucket
       prefix = "gcp-platform-iac/lab"
     }
   }
   ```

   Do the same for `envs/prod/backend.tf` when you start using it.

---

## 4. Configure the **lab** environment

Go to the lab env folder:

```bash
cd envs/lab
```

Create your `terraform.tfvars` from the example:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and adjust values as needed:

```hcl
project_id       = "CHANGE_ME_PROJECT_ID"
region           = "us-central1"
network_name     = "lab-vpc"
subnetwork_name  = "lab-subnet-us-central1"
subnetwork_cidr  = "10.10.0.0/24"
cluster_name     = "lab-autopilot"
artifact_repo_id = "lab-docker"
gke_sa_name      = "lab-gke-workload"
```

Defaults are reasonable for a simple lab; you can tweak names and CIDRs if you want to avoid clashes.

---

## 5. Initialize and apply Terraform (lab)

Still inside `envs/lab`:

```bash
terraform init
terraform plan
terraform apply
```

Terraform will:

- Create a custom VPC and subnetwork.
- Create an Autopilot GKE cluster.
- Create an Artifact Registry Docker repo in the chosen region.
- Create a generic workload/CI service account with basic logging/metrics permissions and read access to Artifact Registry.

At the end, Terraform will print outputs like:

- `network_name`
- `subnetwork_name`
- `gke_cluster_name`
- `gke_location`
- `artifact_registry_repo`
- `gke_workload_sa_email`

---

## 6. Connect to the GKE Autopilot cluster

Once `terraform apply` has finished, you can fetch cluster credentials via `gcloud`:

```bash
# From anywhere
export PROJECT_ID="CHANGE_ME_PROJECT_ID"
export REGION="us-central1"
export CLUSTER_NAME="lab-autopilot"

gcloud container clusters get-credentials "$CLUSTER_NAME"   --region "$REGION"   --project "$PROJECT_ID"
```

Then verify:

```bash
kubectl get nodes
kubectl get ns
```

You should see an Autopilot cluster managed by GCP.

---

## 7. Clean up (destroy lab)

When you’re done and want to stop paying for the cluster and related resources, go back to `envs/lab` and:

```bash
terraform destroy
```

Terraform will remove:

- The GKE Autopilot cluster.
- The VPC + subnetwork.
- The Artifact Registry repo.
- The lab service account and its IAM bindings.

> The **GCS state bucket is NOT destroyed** automatically.  
> Delete it manually if you don’t need the Terraform state anymore:
>
> ```bash
> gsutil rm -r gs://CHANGE_ME_TF_STATE_BUCKET
> ```

---

## Common issues & troubleshooting

### 1. Terraform says a service/API is not enabled

Typical error:

> `Error: googleapi: Error 403: Project <id> has not activated the [container.googleapis.com] API`

Fix: ensure all required APIs are enabled **in the same project**:

```bash
gcloud services enable   compute.googleapis.com   container.googleapis.com   artifactregistry.googleapis.com   iam.googleapis.com
```

Then run `terraform apply` again.

---

### 2. Permission / IAM errors when running Terraform

If you see errors like:

> `googleapi: Error 403: Permission denied`  
> or  
> `Required 'container.clusters.create' permission for '<project>'`

The account running Terraform (your user or a CI service account) must have enough rights on the project.

For lab purposes, the simplest is to grant your user **Owner** on the project (in the console) or equivalent roles.

For a stricter setup, you’d give the Terraform runner roles like:

- `roles/compute.networkAdmin`
- `roles/container.admin`
- `roles/artifactregistry.admin`
- `roles/iam.serviceAccountAdmin`
- `roles/resourcemanager.projectIamAdmin` (if managing IAM at project level)

---

### 3. Backend bucket not found during `terraform init`

If `terraform init` fails with:

> `Error: googleapi: Error 404: The specified bucket does not exist`

Check that:

- The bucket name in `envs/lab/backend.tf` matches exactly the one you created.
- The bucket exists and is in the same project or accessible to your account.

You can list buckets with:

```bash
gsutil ls
```

---

### 4. GKE cluster created, but `get-credentials` fails

If you see:

> `ERROR: (gcloud.container.clusters.get-credentials) ResponseError: code=404, message=Not found`

Check:

1. Region vs zone: this module creates a **regional Autopilot** cluster, so you must use `--region`, not `--zone`.
2. That you’re using the correct project:

   ```bash
   gcloud config get-value project
   ```

3. That the cluster name matches the output `gke_cluster_name` from Terraform.

---

### 5. Using this platform with **Cloud Run** & Cloud Build (build permission gotcha)

When you later deploy containers to **Cloud Run** using `gcloud run deploy --source .`, Cloud Run uses **Cloud Build** behind the scenes.

In recent changes, Cloud Build often uses the **Compute Engine default service account** to build images.  
If that account doesn’t have the right role, you may see errors like:

> `PERMISSION_DENIED: Build failed because the default service account is missing required IAM permissions`

A simple lab-friendly fix is to grant the `roles/run.builder` role to the Compute Engine default service account:

```bash
PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects describe "$PROJECT_ID" --format='value(projectNumber)')
COMPUTE_SA="${PROJECT_NUMBER}-compute@developer.gserviceaccount.com"

gcloud projects add-iam-policy-binding "$PROJECT_ID"   --member="serviceAccount:${COMPUTE_SA}"   --role="roles/run.builder"
```

After that, re-run your `gcloud run deploy` command **without** manually overriding `--build-service-account` (let Cloud Run/Cloud Build use their defaults).

---

### 6. Autopilot + subnet size issues

If you later create more clusters or expand usage, Autopilot might complain that the subnet IP range is too small.

This module defaults to a `/24` CIDR for the lab subnet:

```hcl
subnetwork_cidr = "10.10.0.0/24"
```

If you plan to run multiple clusters or many pods, consider:

- Expanding the range to `/20` or similar, e.g. `10.10.0.0/20`.
- Making sure the range does not overlap with other VPCs or on-prem networks you might peer with.

Update `terraform.tfvars` and re-apply.

---

## Notes & next steps

This repo is intentionally minimal and opinionated.  
It’s meant to be a **foundation**, not a final production design.

Typical next steps:

- Add **Cloud SQL** modules and connect GKE / Cloud Run to managed databases.
- Add **Cloud Run** services using the Artifact Registry repo created here.
- Wire in **Cloud Build / Cloud Deploy** for CI/CD pipelines.
- Add **Cloud Monitoring / Logging** dashboards and SLOs on top of this platform.

Feel free to fork, rename modules, or break this into multiple repos as your platform grows.
