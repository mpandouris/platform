resource "google_storage_bucket" "tf-bucket" {
  name          = "tf-bucket-241709"
  location      = var.location
  uniform_bucket_level_access = true
  
  lifecycle {
    prevent_destroy = false  # Prevent Terraform from destroying the bucket
  }
}