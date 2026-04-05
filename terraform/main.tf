terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "7.26.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }

    #  helm = {
    #  source  = "hashicorp/helm"
    #  version = "~> 2.0"
    #}
  }
  
  # backend block for GCS
  #backend "gcs" {
  #  bucket = "tf-bucket-241709"
  #  prefix = "terraform/state"
  #}
}

provider "google" {
  # Configuration options
  project = var.project_id
  region = var.region
  zone = var.zone
}

# load modules section
module "storage" {
  source = "./modules/storage"

  location = var.location
}

module "gke" {
  source = "./modules/gke"

  # set module vars
  project_id = var.project_id
  region     = var.region
  zone       = var.zone
}
#########################