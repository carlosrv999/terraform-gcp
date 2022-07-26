resource "random_string" "random_emoji_sql" {
  length  = 16
  special = false
  lower   = true
  upper   = false
}

resource "random_string" "random_vote_sql" {
  length  = 16
  special = false
  lower   = true
  upper   = false
}

resource "google_sql_database_instance" "cloudsql_emojiapi" {
  name                = "cloudsql-emoji-${random_string.random_emoji_sql.result}"
  database_version    = "MYSQL_8_0"
  region              = "us-central1"
  deletion_protection = false

  depends_on = [
    google_service_networking_connection.private_vpc_connection
  ]

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier              = "db-custom-1-3840"
    availability_type = "ZONAL"
    disk_autoresize   = true
    disk_size         = 10
    disk_type         = "PD_SSD"

    ip_configuration {
      ipv4_enabled    = true
      private_network = google_compute_network.vpc_emojiapp.id

      authorized_networks {
        name  = "my-home"
        value = "38.25.18.114/32"
      }
    }

    backup_configuration {
      binary_log_enabled             = true
      enabled                        = true
      location                       = "us-central1"
      point_in_time_recovery_enabled = false
      start_time                     = "20:00"
      transaction_log_retention_days = 7

      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }

  }
}

resource "google_sql_database_instance" "cloudsql_voteapi" {
  name                = "cloudsql-vote-${random_string.random_vote_sql.result}"
  database_version    = "MYSQL_8_0"
  region              = "us-central1"
  deletion_protection = false

  depends_on = [
    google_service_networking_connection.private_vpc_connection
  ]

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier              = "db-custom-1-3840"
    availability_type = "ZONAL"
    disk_autoresize   = true
    disk_size         = 10
    disk_type         = "PD_SSD"

    ip_configuration {
      ipv4_enabled    = true
      private_network = google_compute_network.vpc_emojiapp.id

      authorized_networks {
        name  = "my-home"
        value = "38.25.18.114/32"
      }
    }

    backup_configuration {
      binary_log_enabled             = true
      enabled                        = true
      location                       = "us-central1"
      point_in_time_recovery_enabled = false
      start_time                     = "20:00"
      transaction_log_retention_days = 7

      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }

  }
}

resource "google_sql_user" "emojiuser" {
  name     = "administrator"
  instance = google_sql_database_instance.cloudsql_emojiapi.name
  password = "DcbTrFuHbVq2We6G3#dB"
  host     = "38.25.18.114/32"

  provisioner "local-exec" {
    command = "mysql -h ${google_sql_database_instance.cloudsql_emojiapi.public_ip_address} -u ${self.name} -p${self.password} < ./initdb/emojidb.sql"
  }

}

resource "google_sql_user" "voteuser" {
  name     = "administrator"
  instance = google_sql_database_instance.cloudsql_voteapi.name
  password = "DcbTrFuHbVq2We6G3#dB"
  host     = "38.25.18.114/32"

  provisioner "local-exec" {
    command = "mysql -h ${google_sql_database_instance.cloudsql_voteapi.public_ip_address} -u ${self.name} -p${self.password} < ./initdb/votedb.sql"
  }

}

output "emoji_db_ip" {
  value = google_sql_database_instance.cloudsql_emojiapi.private_ip_address
}

output "vote_db_ip" {
  value = google_sql_database_instance.cloudsql_voteapi.private_ip_address
}
