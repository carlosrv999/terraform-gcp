resource "google_container_cluster" "cluster-emojiapp" {
  name               = "cluster-emojiapp"
  network            = google_compute_network.vpc_emojiapp.name
  subnetwork         = google_compute_subnetwork.subnet_emojiapp_1.name
  initial_node_count = 1
  location           = "us-central1"
  networking_mode    = "VPC_NATIVE"

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

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }

    http_load_balancing {
      disabled = false
    }

  }

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

  provisioner "local-exec" {
    when    = destroy
    command = "bash delete-application-resources.sh"
  }

}

resource "null_resource" "update_manifests" {
  provisioner "local-exec" {
    command = "bash update-manifests.sh ${google_sql_database_instance.cloudsql_emojiapi.private_ip_address} ${google_sql_database_instance.cloudsql_voteapi.private_ip_address}"
  }

  depends_on = [
    google_sql_user.emojiuser,
    google_sql_user.voteuser,
  ]

}

resource "null_resource" "install_argo" {
  provisioner "local-exec" {
    command = "bash install-argocd.sh us-central1 ${google_container_cluster.cluster-emojiapp.name}"
  }

  depends_on = [
    google_sql_user.emojiuser,
    google_sql_user.voteuser,
  ]

}
