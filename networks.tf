resource "google_compute_network" "vpc_emojiapp" {
  name                    = "vpc-emojiapp"
  auto_create_subnetworks = false
  mtu                     = 1460
  description             = "vpc for emojiapp"
  routing_mode            = "REGIONAL"

}

resource "google_compute_subnetwork" "subnet_emojiapp_1" {
  name                     = "subnet-emojiapp-1"
  ip_cidr_range            = "10.100.0.0/21"
  network                  = google_compute_network.vpc_emojiapp.id
  description              = "subnet 1 for emojiapp"
  stack_type               = "IPV4_ONLY"
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "subnet_emojiapp_2" {
  name                     = "subnet-emojiapp-2"
  ip_cidr_range            = "10.100.8.0/21"
  network                  = google_compute_network.vpc_emojiapp.id
  description              = "subnet 2 for emojiapp"
  stack_type               = "IPV4_ONLY"
  private_ip_google_access = true
}

resource "google_compute_firewall" "vpc_emojiapp" {
  name    = "ssh"
  network = google_compute_network.vpc_emojiapp.name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["38.25.18.114/32"]

  target_service_accounts = ["819128255673-compute@developer.gserviceaccount.com"]

}

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 20
  address       = "10.100.32.0"
  network       = google_compute_network.vpc_emojiapp.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc_emojiapp.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_compute_global_address" "ip_api" {
  name         = "global-voteapi-ip"
  address_type = "EXTERNAL"
}

resource "google_compute_global_address" "ip_webapp_emojivote_api" {
  name         = "global-webapp-emojivote-ip"
  address_type = "EXTERNAL"
}
