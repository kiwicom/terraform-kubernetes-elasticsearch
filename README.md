# terraform-kubernetes-elasticsearch

Elasticsearch module for Kubernetes based on [elastic Helm charts](https://github.com/elastic/helm-charts/tree/master/elasticsearch).

## Usage

```hcl-terraform
resource "kubernetes_storage_class" "es_ssd" {
  metadata {
    name = "es-ssd"
  }
  storage_provisioner = "kubernetes.io/gce-pd"
  parameters          = {
    type = "pd-ssd"
  }
}

module "elasticsearch_client" {
  source                = "./elasticsearch"
  node_group            = "client"
  es_version            = "6.2.3"
  namespace             = "storage"
  replicas              = 2
  master_eligible_nodes = 3
  storage_class_name    = kubernetes_storage_class.es_ssd.metadata[0].name
  storage_size          = "1Gi"
}

module "elasticsearch_master" {
  source                = "./elasticsearch"
  node_group            = "master"
  es_version            = "6.2.3"
  namespace             = "storage"
  replicas              = 3
  master_eligible_nodes = 3
  storage_class_name    = kubernetes_storage_class.es_ssd.metadata[0].name
  storage_size          = "5Gi"
}

module "elasticsearch_data" {
  source                = "./elasticsearch"
  node_group            = "data"
  es_version            = "6.2.3"
  namespace             = "storage"
  replicas              = 3
  master_eligible_nodes = 3
  storage_class_name    = kubernetes_storage_class.es_ssd.metadata[0].name
  storage_size          = "20Gi"
}
```

### Variables

In order to check which variables are customizable, check `variables.tf`.
