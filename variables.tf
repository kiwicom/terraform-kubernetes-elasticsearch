variable "cluster_name" {
  type        = string
  default     = "elasticsearch-cluster"
  description = "Elasticsearch cluster name and relase name"
}

variable "node_group" {
  type        = string
  default     = "master"
  description = "This is the name that will be used for each group of nodes in the cluster (values: client, master, node)"
}

variable "es_version" {
  type        = string
  description = "Elasticsearch version (6.4.2+, 7.0.0+)"
}

variable "namespace" {
  type        = string
  default     = "storage"
  description = "Namespace in which service will be deployed"
}

variable "helm_install_timeout" {
  type        = number
  default     = 900
  description = "Time in seconds to wait for any individual kubernetes operation (like Jobs for hooks)"
}

variable "replicas" {
  type        = number
  default     = 0
  description = "Kubernetes replica count for the statefulset (i.e. how many pods)"
}

variable "master_eligible_nodes" {
  type        = number
  default     = 3
  description = "Number of master eligible nodes used to calculate minimumMasterNodes"
}

variable "termination_grace_period" {
  type        = number
  default     = 120
  description = "The terminationGracePeriod in seconds used when trying to stop the pod"
}

variable "es_java_opts" {
  type        = string
  default     = "-Xmx1g -Xms1g"
  description = "Java options for Elasticsearch. This is where you should configure the jvm heap size. Can be around half of requests memory."
}

variable "storage_class_name" {
  type        = string
  default     = "ssd"
  description = "Storage class name"
}

variable "storage_size" {
  type        = string
  default     = "30Gi"
  description = "Storage size of the storageClassName"
}

variable "resources" {
  type = object({
    requests = object({
      cpu    = string
      memory = string
    })
    limits   = object({
      cpu    = string
      memory = string
    })
  })

  default = {
    requests = {
      cpu    = "1000m"
      memory = "2Gi"
    }
    limits   = {
      cpu    = "1000m"
      memory = "2Gi"
    }
  }

  description = "Allows you to set the resources for the statefulset"
}

locals {
  default_replicas = {
    "client" = 2
    "master" = 3
    "data"   = 3
  }

  replicas = var.replicas != 0 ? var.replicas : local.default_replicas[var.node_group]

  master_service = "${var.cluster_name}-master"

  minimum_master_nodes = floor((var.master_eligible_nodes / 2) + 1)
}
