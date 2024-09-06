resource "google_compute_address" "global_ip" {
  name         = var.network_options.global_ip_name
  address_type = "EXTERNAL"
  region       = var.region
}
resource "null_resource" "wait_for_ip" {
  depends_on = [google_compute_address.global_ip]
  provisioner "local-exec" {
    command = "sleep 30"
  }
}
resource "google_compute_router" "nat_router" {
  name    = var.network_options.nat_router_name
  network = data.google_compute_network.default.name
  region  = var.region
}
resource "google_compute_router_nat" "nat" {
  name                               = var.network_options.nat_name
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.global_ip.self_link]
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  depends_on = [
    google_compute_address.global_ip,
    google_compute_router.nat_router,
    null_resource.wait_for_ip,
  ]
}
