terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

locals {
  timestamp = timestamp()
}

resource "random_integer" "product" {
  min = 0
  max = length(local.hashi_products) - 1
  keepers = {
    "timestamp" = local.timestamp
  }
}

resource "google_compute_network" "hashicafe" {
  name                    = "${var.prefix}-vpc-${var.region}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "hashicafe" {
  name          = "${var.prefix}-subnet"
  region        = var.region
  network       = google_compute_network.hashicafe.self_link
  ip_cidr_range = var.subnet_prefix
}

resource "google_compute_firewall" "http-server" {
  name    = "${var.prefix}-default-allow-ssh-http"
  network = google_compute_network.hashicafe.self_link

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

resource "tls_private_key" "ssh-key" {
  algorithm = "ED25519"
  rsa_bits  = "4096"
}

resource "google_compute_instance" "hashicafe" {
  name         = "${var.prefix}-hashicafe"
  zone         = var.zone
  machine_type = var.machine_type
  metadata_startup_script = file("${path.module}/startup.sh")

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.hashicafe.self_link
    access_config {
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${chomp(tls_private_key.ssh-key.public_key_openssh)} terraform"
  }

  tags = ["http-server"]

  labels = {
    name = "hashicafe"
  }

}

# We're using a little trick here so we can run the provisioner without
# destroying the VM. Do not do this in production.

resource "null_resource" "configure-web-app" {
  depends_on = [google_compute_instance.hashicafe]

  triggers = {
    build_number = local.timestamp
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.ssh-key.private_key_pem
    host        = google_compute_instance.hashicafe.network_interface.0.access_config.0.nat_ip
  }

  provisioner "remote-exec" {
    inline = [
      # Make sure the startup script has finished running
      "until [ -f /etc/startup_script_done ]; do sleep 5; done",
      "sudo mkdir -p /var/www/html/img",
      "sudo chown -R ubuntu:ubuntu /var/www/html"
    ]
  }

  provisioner "file" {
    content = templatefile("files/index.html", {
      product_name  = local.hashi_products[random_integer.product.result].name
      product_color = local.hashi_products[random_integer.product.result].color
      product_image = local.hashi_products[random_integer.product.result].image_file
    })
    destination = "/var/www/html/index.html"
  }

  provisioner "file" {
    source      = "files/img/"
    destination = "/var/www/html/img"
  }
}

locals {
  hashi_products = [
    {
      name       = "Consul"
      color      = "#dc477d"
      image_file = "hashicafe_art_consul.png"
    },
    {
      name       = "HCP"
      color      = "#ffffff"
      image_file = "hashicafe_art_hcp.png"
    },
    {
      name       = "Nomad"
      color      = "#60dea9"
      image_file = "hashicafe_art_nomad.png"
    },
    {
      name       = "Packer"
      color      = "#63d0ff"
      image_file = "hashicafe_art_packer.png"
    },
    {
      name       = "Terraform"
      color      = "#844fba"
      image_file = "hashicafe_art_terraform.png"
    },
    {
      name       = "Vagrant"
      color      = "#2e71e5"
      image_file = "hashicafe_art_vagrant.png"
    },
    {
      name       = "Vault"
      color      = "#ffec6e"
      image_file = "hashicafe_art_vault.png"
    }
  ]
}
