resource "google_compute_instance" "default" {
  name         = count.index > 5 ? "docker-vm-${count.index}-${var.region_b}" : "docker-vm-${count.index}-${var.region_a}"
  machine_type = var.vm-type
  count        = length(var.instance_tag)
  zone         = count.index > 5 ? var.zone_b : var.zone_a
  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-2204-jammy-v20240829"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
  metadata_startup_script = templatefile("scripts/startup.sh", {
    username  = element(var.instance_tag, count.index),
    password  = "${element(var.instance_tag, count.index)}-${var.ssh_password}",
    instance  = count.index,
    sa-config = data.google_service_account_key.sa-account-key.public_key,
    region    = var.region_a
  })
  tags = [var.lab_tag]
}