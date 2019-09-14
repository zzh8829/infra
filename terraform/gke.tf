resource "google_container_cluster" "cluster" {
  name     = "${var.name}-gke"
  location = "${var.region}-a"

  network = "${google_compute_network.vpc.name}"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  addons_config {
    http_load_balancing {
      disabled = true
    }

    kubernetes_dashboard {
      disabled = true
    }
  }
}

resource "google_container_node_pool" "f1-micro" {
  name     = "f1-micro-pool"
  location = "${var.region}-a"
  cluster  = "${google_container_cluster.cluster.name}"

  initial_node_count = "1"
  autoscaling {
    min_node_count = "1"
    max_node_count = "1"
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    machine_type = "f1-micro"
    disk_size_gb = 30

    metadata = {
      disable-legacy-endpoints = true
    }

    tags = [
      tolist(google_compute_firewall.http.target_tags)[0],
      tolist(google_compute_firewall.https.target_tags)[0]
    ]

    # Needed for correctly functioning cluster, see
    # https://www.terraform.io/docs/providers/google/r/container_cluster.html#oauth_scopes
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }
}

resource "google_container_node_pool" "g1-small" {
  name     = "g1-small-pool"
  location = "${var.region}-a"
  cluster  = "${google_container_cluster.cluster.name}"

  initial_node_count = "1"
  autoscaling {
    min_node_count = "1"
    max_node_count = "1"
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    preemptible  = true
    machine_type = "g1-small"
    disk_size_gb = 30

    metadata = {
      disable-legacy-endpoints = true
    }

    tags = [
      tolist(google_compute_firewall.http.target_tags)[0],
      tolist(google_compute_firewall.https.target_tags)[0]
    ]

    # Needed for correctly functioning cluster, see
    # https://www.terraform.io/docs/providers/google/r/container_cluster.html#oauth_scopes
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }
}

data "template_file" "kubeconfig" {
  template = file("${path.module}/kubeconfig-template.yaml")

  vars = {
    cluster_name = google_container_cluster.cluster.name
    endpoint     = google_container_cluster.cluster.endpoint
    cluster_ca   = google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
  }
}
