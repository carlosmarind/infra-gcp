resource "google_compute_instance" "default" {
  name         = "vm-${count.index}"
  machine_type = var.vm-type
  count        = length(var.instance_tag)
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-2204-jammy-v20240829"
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
  metadata = {
    ssh-keys = "${split("@", data.google_client_openid_userinfo.me.email)[0]}:${tls_private_key.ssh.public_key_openssh}"
  }
  tags = [var.lab_tag]
}
