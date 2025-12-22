terraform {
  backend "gcs" {
    bucket  = "python-app-kubernetes-backend"
    prefix  = "dev/python-restful-api"
  }

  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

provider "google" {}
