terraform {
  required_version = ">= 0.13"
  required_providers {
    datadog = {
      source = "DataDog/datadog"
      version = "~> 3.0.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 1.3.2"
    }
  }
}
