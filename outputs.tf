output "app_url" {
  description = "URL of the deployed webapp."
  value = "http://${google_compute_instance.hashicafe.network_interface.0.access_config.0.nat_ip}"
}

output "product" {
  description = "The product which was randomly selected."
  value       = var.hashi_products[random_integer.product.result].name
}
