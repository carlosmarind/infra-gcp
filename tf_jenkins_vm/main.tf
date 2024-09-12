resource "google_compute_instance" "default" {
  name         = "jenkins"
  machine_type = var.vm-type
  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-2204-jammy-v20240829"
    }
  }

  network_interface {
    network = "default"
    access_config {
       nat_ip = "${google_compute_address.ip-global-jenkins.address}"
    }
  }
  metadata_startup_script = templatefile("scripts/startup.sh", {
    username  = "jenkins"
    password  = "jenmdev01.2024",
    region    = var.region_a
  })
  metadata = {
    ssh-keys = "carlosmarind:${file("~/.ssh/id_rsa.pub")}"
  }
  tags = ["jenkins"]
}