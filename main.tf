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

# Create a Compute Engine instance
resource "google_compute_instance" "my_instance" {
  name         = "my-instance"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = data.terraform_remote_state.my_network.outputs.network_self_link
    subnetwork = data.terraform_remote_state.my_network.outputs.subnet_self_link
  }
}

# Output the instance public IP
output "instance_public_ip" {
  value = google_compute_instance.my_instance.network_interface.0.access_config.0.nat_ip
}

