terraform {
  required_version = ">= 0.13"
  required_providers {
    datadog = {
      source = "DataDog/datadog"
      version = "~> 2.19.1"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 1.3.2"
    }
  }
}
