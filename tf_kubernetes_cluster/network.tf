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
resource "google_compute_address" "lb-ip-ingress" {
  name         = "lb-ip-ingress"
  address_type = "EXTERNAL"
  region       = var.region
}

resource "google_dns_record_set" "kubernetes_devops_cl" {
  name         = "*.${data.google_dns_managed_zone.devops_cl.dns_name}"
  managed_zone = data.google_dns_managed_zone.devops_cl.name
  type         = "A"
  ttl          = 300
  rrdatas = [
    google_compute_address.lb-ip-ingress.address
  ]
}

