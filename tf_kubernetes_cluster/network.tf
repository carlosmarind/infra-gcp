#resource "google_compute_network" "vpc_network" {
#  name                    = var.network_options.vpc_name
#  auto_create_subnetworks = false
#  depends_on              = [null_resource.prep]
#}
resource "google_compute_subnetwork" "subnetwork" {
  name          = var.network_options.subnet_name
  ip_cidr_range = var.network_options.gke_node_cidr
  region        = var.region
  network       = data.google_compute_network.default.id
  secondary_ip_range {
    range_name    = "pods-subnet"
    ip_cidr_range = var.network_options.pods_cidr
  }
  secondary_ip_range {
    range_name    = "services-subnet"
    ip_cidr_range = var.network_options.svc_cidr
  }
  depends_on = [
    data.google_compute_network.default,
  ]
}

data "google_compute_network" "default" {
  name = "default"
}
data "google_compute_subnetwork" "default" {
  name = "default"
}

data "google_compute_subnetwork" "east_default" {
  name = "default"
  region = var.second_region
}
#resource "google_compute_network_peering" "peering_bastion" {
#  name         = "peering-default-${var.network_options.vpc_name}"
#  network      = data.google_compute_network.default.self_link
#  peer_network = google_compute_network.vpc_network.self_link
#}
#
#resource "google_compute_network_peering" "peering_default" {
#  name         = "peering-default-${var.network_options.vpc_name}"
#  network      = google_compute_network.vpc_network.self_link
#  peer_network = data.google_compute_network.default.self_link
#}