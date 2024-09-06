provider "google" {
  project = var.project
  region  = var.region
}


## Artifact Registry
resource "google_artifact_registry_repository" "docker-repository" {
  location      = var.region
  repository_id = "docker-repository"
  description   = "docker repository for devops class"
  format        = "DOCKER"

  docker_config {
    immutable_tags = false
  }
}

resource "google_service_account" "sa-registry" {
  account_id                   = "sa-registry"
  project                      = var.project
  display_name                 = "Service Account for Artifact Registry"
  create_ignore_already_exists = true
}

data "google_iam_policy" "admin" {
  binding {
    role = "roles/artifactregistry.repoAdmin"
    members = [
      google_service_account.sa-registry.member
    ]
  }
}

resource "google_artifact_registry_repository_iam_policy" "policy" {
  project     = google_artifact_registry_repository.docker-repository.project
  location    = google_artifact_registry_repository.docker-repository.location
  repository  = google_artifact_registry_repository.docker-repository.name
  policy_data = data.google_iam_policy.admin.policy_data
}
resource "google_service_account_key" "key" {
  service_account_id = google_service_account.sa-registry.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}
resource "local_file" "service_account" {
  content  = base64decode(google_service_account_key.key.private_key)
  filename = "${path.module}/serviceaccount.json"
}
output "private_key_instructions" {
  value = "The service_account key has been saved to serviceaccount.json. Handle it securely."
}
