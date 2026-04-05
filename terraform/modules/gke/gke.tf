# GKE Cluster resource
resource "google_container_cluster" "primary_cluster" {
  name     = "primary-cluster"
  location = var.zone

  initial_node_count = 3
  project            = var.project_id

  # Optional for monitoring:
  # enable_stackdriver_kubernetes = true
  # enable_monitoring             = true

   # Disable deletion protection
  deletion_protection = false
}

# Data source for the current Google Cloud client configuration (credentials)
data "google_client_config" "current" {}

# Data source for GKE cluster
data "google_container_cluster" "primary_cluster" {
  name     = google_container_cluster.primary_cluster.name
  location = var.zone
  project  = var.project_id
}

# Kubernetes provider
provider "kubernetes" {
  host  = "https://${data.google_container_cluster.primary_cluster.endpoint}"
  token = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.primary_cluster.master_auth[0].cluster_ca_certificate,
  )
}

# Create namespaces by looping through the list of namespaces defined in variables.tf
resource "kubernetes_namespace_v1" "envs" {
  for_each = toset(var.namespaces)
  metadata {
    name = each.value
  }
}