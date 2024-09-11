data "google_compute_network" "default" {
  name = "default"
}
data "google_compute_subnetwork" "default" {
  name = "default"
}

data "google_compute_subnetwork" "east_default" {
  name   = "default"
  region = var.second_region
}
data "google_dns_managed_zone" "devops_cl" {
  name = "devops-cl"
} 