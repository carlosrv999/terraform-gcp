resource "google_container_node_pool" "default-pool" {
    cluster                     = "cluster-1"
    id                          = "projects/terraformdemo-355914/locations/us-central1/clusters/cluster-1/nodePools/default-pool"
    initial_node_count          = 1
    instance_group_urls         = [
        "https://www.googleapis.com/compute/v1/projects/terraformdemo-355914/zones/us-central1-c/instanceGroupManagers/gke-cluster-1-default-pool-969c292e-grp",
        "https://www.googleapis.com/compute/v1/projects/terraformdemo-355914/zones/us-central1-f/instanceGroupManagers/gke-cluster-1-default-pool-efd3be0d-grp",
        "https://www.googleapis.com/compute/v1/projects/terraformdemo-355914/zones/us-central1-a/instanceGroupManagers/gke-cluster-1-default-pool-cfe63be8-grp",
    ]
    location                    = "us-central1"
    managed_instance_group_urls = [
        "https://www.googleapis.com/compute/v1/projects/terraformdemo-355914/zones/us-central1-c/instanceGroups/gke-cluster-1-default-pool-969c292e-grp",
        "https://www.googleapis.com/compute/v1/projects/terraformdemo-355914/zones/us-central1-f/instanceGroups/gke-cluster-1-default-pool-efd3be0d-grp",
        "https://www.googleapis.com/compute/v1/projects/terraformdemo-355914/zones/us-central1-a/instanceGroups/gke-cluster-1-default-pool-cfe63be8-grp",
    ]
    max_pods_per_node           = 110
    name                        = "default-pool"
    node_count                  = 1
    node_locations              = [
        "us-central1-a",
        "us-central1-c",
        "us-central1-f",
    ]
    project                     = "terraformdemo-355914"
    version                     = "1.22.8-gke.202"

    management {
        auto_repair  = true
        auto_upgrade = true
    }

    node_config {
        disk_size_gb      = 100
        disk_type         = "pd-standard"
        guest_accelerator = []
        image_type        = "COS_CONTAINERD"
        labels            = {}
        local_ssd_count   = 0
        machine_type      = "n2-standard-2"
        metadata          = {
            "disable-legacy-endpoints" = "true"
        }
        min_cpu_platform  = "Intel Ice Lake"
        oauth_scopes      = [
            "https://www.googleapis.com/auth/devstorage.read_only",
            "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring",
            "https://www.googleapis.com/auth/service.management.readonly",
            "https://www.googleapis.com/auth/servicecontrol",
            "https://www.googleapis.com/auth/trace.append",
        ]
        preemptible       = false
        service_account   = "default"
        spot              = false
        tags              = []
        taint             = []

        shielded_instance_config {
            enable_integrity_monitoring = true
            enable_secure_boot          = false
        }
    }

    timeouts {}

    upgrade_settings {
        max_surge       = 1
        max_unavailable = 0
    }
}