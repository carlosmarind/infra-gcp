resource "google_service_account" "sa-k8-lab" {
  account_id   = "sa-k8-lab"
  display_name = "Service Account Kubernetes lab"
}

resource "google_container_cluster" "primary" {
  name     = var.gke_options.cluster_name
  location = var.zone

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  # Set `deletion_protection` to `true` will ensure that one cannot
  # accidentally delete this instance by use of Terraform.
  deletion_protection = false

  network    = data.google_compute_network.default.name
  subnetwork = google_compute_subnetwork.subnetwork.name

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods-subnet"
    services_secondary_range_name = "services-subnet"
  }
  private_cluster_config {
    enable_private_endpoint = var.gke_options.enable_private_endpoint
    enable_private_nodes    = var.gke_options.enable_private_nodes
    master_ipv4_cidr_block  = var.gke_options.master_ipv4_cidr_block
    master_global_access_config {
      enabled = true
    }
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = var.network_options.gke_node_cidr
    }
    cidr_blocks {
      cidr_block = data.google_compute_subnetwork.default.ip_cidr_range
    }
    cidr_blocks {
      cidr_block = data.google_compute_subnetwork.east_default.ip_cidr_range
    }
  }
  default_max_pods_per_node = 50

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }
    http_load_balancing {
      disabled = false
    }
    network_policy_config {
      disabled = true
    }
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = var.gke_options.node_pool_name
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = 3

  node_config {
    preemptible  = false
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.sa-k8-lab.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
