resource "google_compute_instance" "default" {
  name         = "vm-${count.index}"
  machine_type = var.vm-type
  count        = length(var.instance_tag)
  zone         = count.index < 8 ? var.zone_a : count.index < 16 ? var.zone_b : count.index < 24 ? var.zone_c : var.zone_d
  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-2204-jammy-v20240829"
      size  = 10
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
  metadata_startup_script = templatefile("scripts/startup.sh", {
    username = element(var.instance_tag, count.index),
    password = "${element(var.instance_tag, count.index)}-${var.ssh_password}",
  })
  tags = [var.lab_tag]
}
