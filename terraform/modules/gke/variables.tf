# gke.tf inside modules/gke
variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "The region for Google Cloud resources"
  type        = string
}

variable "zone" {
  description = "The zone for GKE and other resources"
  type        = string
}

variable "namespaces" {
  description = "list of namespaces to create"
  type = list(string)
  default = [ "dev", "uat", "production"]
}