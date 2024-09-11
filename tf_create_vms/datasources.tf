data "google_service_account" "sa-account" {
  account_id = "sa-registry"
}


## Artifact Registry
resource "google_service_account_key" "sa-account-key" {
  service_account_id = data.google_service_account.sa-account.id
}


data "google_service_account_key" "sa-account-key" {
  name            = google_service_account_key.sa-account-key.name
  public_key_type = "TYPE_X509_PEM_FILE"
}
