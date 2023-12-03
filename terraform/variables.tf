variable "db_name" {
    description = "Database name"
    default = "ecomm-db"
}

variable "project_id" {
    description = "GCP Project ID"
    default = "data-engineering-406915"
}

variable "region" {
    description = "Region of DB to be created"
    default = "asia-south1"
}

variable "db_machine_type" {
    description = "DB instance machine type"
    default = "n1-standard-1"
}