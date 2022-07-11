resource "google_container_cluster" "cluster-1" {
  name = "cluster-1"

  addons_config {

    horizontal_pod_autoscaling {
      disabled = false
    }

    http_load_balancing {
      disabled = false
    }

  }

  enable_autopilot = false

  initial_node_count = 0

  location        = "us-central1"
  networking_mode = "VPC_NATIVE"

  logging_config {
    enable_components = [
      "SYSTEM_COMPONENTS",
      "WORKLOADS",
    ]
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.191.0.0/17"
    services_ipv4_cidr_block = "10.191.128.0/21"
  }

  release_channel {
    channel = "REGULAR"
  }

  default_snat_status {
    disabled = false
  }

}

resource "google_container_node_pool" "default-pool" {
  cluster            = google_container_cluster.cluster-1.name
  name               = "default-pool"
  initial_node_count = 1
  location           = "us-central1"

  node_locations = [
    "us-central1-a",
    "us-central1-c",
    "us-central1-f",
  ]

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  oauth_scopes = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]

  node_config {
    image_type       = "COS_CONTAINERD"
    local_ssd_count  = 0
    machine_type     = "n2-standard-2"
    min_cpu_platform = "Intel Ice Lake"
    preemptible      = false
    service_account  = "default"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    metadata = {
      "disable-legacy-endpoints" = "true"
    }

    shielded_instance_config {
      enable_integrity_monitoring = true
      enable_secure_boot          = false
    }

  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

}
