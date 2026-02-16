# Root Module: backend.tf
terraform {
  backend "gcs" {
    bucket = "rohith_tfstate"  
    prefix = "workload identity/github-wif"              
  }
}