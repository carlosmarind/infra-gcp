#resource "google_compute_instance" "bastion" {
#  name         = var.bastion_options.bastion_name
#  machine_type = var.bastion_options.bastion_machine_type
#  zone         = var.zone
#  boot_disk {
#    initialize_params {
#      image = var.bastion_options.bastion_image
#    }
#  }
#  network_interface {
#    network    = data.google_compute_network.default.self_link
#    subnetwork = google_compute_subnetwork.subnetwork.self_link
#  }
#  metadata_startup_script = var.bastion_options.bastion_startup_script
#  tags                    = var.bastion_options.bastion_tags
#}
#
#resource "google_compute_firewall" "allow_ssh_bastion" {
#  name    = var.firewall_options.firewall_name
#  network = data.google_compute_network.default.self_link
#  allow {
#    protocol = "tcp"
#    ports    = var.firewall_options.firewall_ports
#  }
#  allow {
#    protocol = "icmp"
#
#  }
#  source_ranges = var.firewall_options.firewall_source_ranges
#  target_tags   = var.firewall_options.firewall_target_tags
#}
#
#resource "google_service_account" "bastion_sa" {
#  account_id   = "bastion-sa"
#  display_name = "Bastion Service Account"
#}
#resource "google_project_iam_member" "bastion_sa_roles" {
#  for_each = toset(var.service_account_roles)
#  project  = var.project_id
#  member   = "serviceAccount:${google_service_account.bastion_sa.email}"
#  role     = each.value
#}
