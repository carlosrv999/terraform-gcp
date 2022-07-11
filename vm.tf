/*resource "google_compute_instance" "maquinaprueba" {
  name         = "testvm"
  machine_type = "n2-standard-2"
  zone         = "us-central1-c"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet_emojiapp_1.name

    access_config {
      network_tier = "STANDARD"
    }
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}*/