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

resource "google_compute_firewall" "http-server" {
  name    = "default-allow-http-terraform"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  allow {
    protocol = "udp"
    ports    = ["22"]
  }
  allow {
    protocol = "sctp"
    ports    = ["22"]
  }
  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
 
}

output "ip" {
  value = google_compute_instance.default[*].network_interface.0.access_config.0.nat_ip
}


#### If you want to create a DNS zone####
resource "google_dns_managed_zone" "devops_cl" {
  name          = "devops-cl"
  dns_name      = "devops.cl."
  description   = "devops.cl Public DNS zone"
  force_destroy = "true"
}
data "google_compute_network" "default" {
  name = "default"
}
#resource "google_dns_managed_zone" "private_devops_cl" {
#  name          = "private-devops-cl"
#  dns_name      = "devops.cl."
#  description   = "devops.cl Private DNS zone"
#  force_destroy = "true"
#  visibility    = "private"
#  private_visibility_config {
#    networks {
#      network_url = data.google_compute_network.default.id
#    }
#  }
#}

## to register web-server's ip address in DNS
resource "google_dns_record_set" "devops_cl" {
  count        = length(var.instance_tag)
  name         = "${google_compute_instance.default[count.index].name}.${google_dns_managed_zone.devops_cl.dns_name}"
  managed_zone = google_dns_managed_zone.devops_cl.name
  type         = "A"
  ttl          = 300
  rrdatas = [
    google_compute_instance.default[count.index].network_interface.0.access_config.0.nat_ip
  ]
}

## Artifact Registry
resource "google_service_account_key" "key" {
  service_account_id = "sa-registry@${var.project}.iam.gserviceaccount.com"
  public_key_type    = "TYPE_X509_PEM_FILE"
}
