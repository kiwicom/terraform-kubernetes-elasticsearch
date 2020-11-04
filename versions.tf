terraform {
  required_version = ">= 0.13"
  required_providers {
    datadog = {
      source = "terraform-providers/datadog"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}
