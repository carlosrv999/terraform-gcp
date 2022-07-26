resource "google_dns_record_set" "frontend_www" {
  name = "www.carlosramirezvera.org."
  type = "A"
  ttl  = 300

  managed_zone = "emojivote"

  rrdatas = [ google_compute_global_address.ip_webapp_emojivote_api.address ]
}

resource "google_dns_record_set" "frontend" {
  name = "carlosramirezvera.org."
  type = "A"
  ttl  = 300

  managed_zone = "emojivote"

  rrdatas = [ google_compute_global_address.ip_webapp_emojivote_api.address ]
}

resource "google_dns_record_set" "api" {
  name = "api.carlosramirezvera.org."
  type = "A"
  ttl  = 300

  managed_zone = "emojivote"

  rrdatas = [ google_compute_global_address.ip_api.address ]
}
