terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}
# Define provider configuration
provider "google" {
  project     = "hc-a0411e550991411898ee2ce2c2e"
  region      = "us-central1"
}
# Reference the network from the Network Workspace
data "terraform_remote_state" "my_network" {
  backend = "remote"
  config = {
    organization = "devopsmayur"
    workspaces = {
      name = "gcpnetwork"
    }
  }
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

  network_interface {
    network = data.terraform_remote_state.my_network.outputs.network_self_link
  }
}

