terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  project = "hc-a0411e550991411898ee2ce2c2e"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
}
data "terraform_remote_state" "vpc_network" {
  backend = "remote"

  config = {
    organization = "hashicorp"
    workspaces = {
      name = "gcpnetwork"
    }
  }
}
