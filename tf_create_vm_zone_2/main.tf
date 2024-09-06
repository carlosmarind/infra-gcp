provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_instance" "default" {
  name         = "docker-vm-${count.index}-${var.region}"
  machine_type = var.vm-type
  count        = length(var.instance_tag)

  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-2204-jammy-v20240829"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
  metadata_startup_script = templatefile("startup.sh", { username = element(var.instance_tag, count.index), password = "${element(var.instance_tag, count.index)}-${var.ssh_password}", instance = count.index, sa-config = google_service_account_key.key.private_key, region = var.region })
  tags                    = [element(var.instance_tag, count.index), "http-server"]
}

output "ip" {
  value = google_compute_instance.default[*].network_interface.0.access_config.0.nat_ip
}

## to register web-server's ip address in DNS
resource "google_dns_record_set" "devops_cl" {
  count        = length(var.instance_tag)
  name         = "${google_compute_instance.default[count.index].name}.devops.cl."
  managed_zone = "devops-cl"
  type         = "A"
  ttl          = 300
  rrdatas = [
    google_compute_instance.default[count.index].network_interface.0.access_config.0.nat_ip
  ]
}

resource "google_service_account_key" "key" {
  service_account_id = "sa-registry@${var.project}.iam.gserviceaccount.com"
  public_key_type    = "TYPE_X509_PEM_FILE"
}
