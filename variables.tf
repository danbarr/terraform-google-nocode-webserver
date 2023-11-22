variable "prefix" {
  type        = string
  description = "This prefix will be included in the name of most resources."
}

variable "project" {
  type        = string
  description = "ID of your GCP project."
}

variable "region" {
  type        = string
  description = "The region where the resources are created."
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "The zone where the resources are created."
  default     = "us-central1-b"
}

variable "subnet_prefix" {
  type        = string
  description = "The address prefix to use for the subnet."
  default     = "10.0.10.0/24"
}

variable "machine_type" {
  type        = string
  description = "Specifies the GCP instance type."
  default     = "g1-small"
}
