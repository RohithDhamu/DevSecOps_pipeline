terraform {
  backend "gcs" {
    bucket  = "rohith_tfstate"
    prefix  = "gke"
  }
}
