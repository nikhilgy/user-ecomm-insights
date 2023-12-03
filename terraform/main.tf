

# cloud sql instance

# Postgresql Instance
module "sql-db_postgresql" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "17.1.0"
  # insert the 3 required variables here
  name                = var.db_name
  project_id          = var.project_id
  region              = var.region
  database_version    = "POSTGRES_14"
  deletion_protection = false
  edition = "ENTERPRISE"
  user_name = "root"

}

# Data Bucket
resource "google_storage_bucket" "ecomm-data-bucket" {
  name          = "ecomm-data-bucket"
  location      = "asia-south1"
  project       = var.project_id
  force_destroy = true

}

# Raw Bigquery Dataset
resource "google_bigquery_dataset" "staging_dataset" {
  dataset_id                  = "staging-ecomm-data"
  friendly_name               = "staging-ecomm-data"
  project                     = var.project_id
  description                 = "This is a staging dataset"
  location                    = "asia-south1"

}

# Table of events and schema
resource "google_bigquery_table" "user_events_table" {
  dataset_id        = google_bigquery_dataset.staging_dataset.dataset_id
  table_id          = "user_events"
  project           = var.project_id
  schema            = file("user_events_schema.json")
  time_partitioning {
    type = "DAY"
  }

}

# Table of User Data and schema
resource "google_bigquery_table" "user_data" {
  dataset_id        = google_bigquery_dataset.staging_dataset.dataset_id
  table_id          = "users"
  project           = var.project_id
  schema            = file("users_schema.json")

}

# Master Bigquery Dataset with views
resource "google_bigquery_dataset" "master_dataset" {
  dataset_id                  = "master-ecomm-data"
  friendly_name               = "master-ecomm-data"
  project                     = var.project_id
  description                 = "This is a master dataset wherein analytics views will be created"
  location                    = "asia-south1"

}

# Cloud Composer environment with files and code to run
resource "google_composer_environment" "ecomm-analysis" {
  provider      = google-beta
  name          = "ecomm-store-analysis"
  region        = "asia-south1"
  project       = var.project_id
  config {
  
    environment_size = "ENVIRONMENT_SIZE_SMALL"

  }
}