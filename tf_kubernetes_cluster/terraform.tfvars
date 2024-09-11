project_id    = "expertis-classroom"
region        = "us-central1"
second_region = "us-east1"
zone          = "us-central1-a"
gke_options = {
  cluster_name            = "my-gke-cluster-lab"
  node_pool_name          = "lab-node-pool"
  enable_private_nodes    = true
  enable_private_endpoint = true
  master_ipv4_cidr_block  = "10.13.0.0/28"
}

network_options = {
  subnet_name     = "lab-subnet"
  vpc_name        = "default"
  pods_cidr       = "10.11.0.0/21"
  svc_cidr        = "10.12.0.0/21"
  nat_name        = "lab-nat"
  global_ip_name  = "lab-global-ip"
  gke_node_cidr   = "10.0.0.0/24"
  nat_router_name = "lab-nat-router"

}

firewall_options = {
  firewall_name          = "allow-ssh-bastion"
  firewall_ports         = ["22"]
  firewall_source_ranges = ["0.0.0.0/0"]
  firewall_target_tags   = ["bastion"]
}

service_account_roles = [
  "roles/logging.logWriter",
  "roles/monitoring.metricWriter",
  "roles/monitoring.viewer",
  "roles/compute.osLogin",
  "roles/compute.admin",
  "roles/iam.serviceAccountUser",
  "roles/container.admin",
  "roles/container.clusterAdmin",
  "roles/compute.osAdminLogin"
]
