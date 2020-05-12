# terraform-kubernetes-elasticsearch

Elasticsearch module for Kubernetes based on [[Elasticsearch Helm charts](https://github.com/elastic/helm-charts/tree/master/elasticsearch). Latest changes from Helm charts are from ([521eb282b72491ea52f430145c2d718375d735ef](https://github.com/elastic/helm-charts/commit/521eb282b72491ea52f430145c2d718375d735ef#diff-18897dcfce6a4e7ae63a3baeed443c48).

## Usage

```hcl-terraform
locals {
  cluster_name          = "elasticsearch-cluster"
  es_version            = "6.8.8"
  master_eligible_nodes = 1
}

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
  source                = "kiwicom/elasticsearch/kubernetes"
  version               = "~> 1.0.0"
  gcp_project_id        = "gcp-project-id"
  # version >= 1.0.0 and < 1.1.0, e.g. 1.0.X
  cluster_name          = local.cluster_name
  node_group            = "client"
  es_version            = local.es_version
  namespace             = "storage"
  replicas              = 1
  master_eligible_nodes = local.master_eligible_nodes

  common_annotations = {
    "janitor/ttl": "10000d",
  }
}

module "elasticsearch_master" {
  source                = "kiwicom/elasticsearch/kubernetes"
  version               = "~> 1.0.0"
  # version >= 1.0.0 and < 1.1.0, e.g. 1.0.X
  node_group            = "master"
  cluster_name          = local.cluster_name
  es_version            = local.es_version
  namespace             = "storage"
  replicas              = 1
  master_eligible_nodes = local.master_eligible_nodes
  storage_class_name    = kubernetes_storage_class.es_ssd.metadata[0].name
  storage_size          = "5Gi"

  common_annotations = {
    "janitor/ttl" = "10000d",
  }
}

module "elasticsearch_data" {
  source                = "kiwicom/elasticsearch/kubernetes"
  version               = "~> 1.0.0"
  # version >= 1.0.0 and < 1.1.0, e.g. 1.0.X
  node_group            = "data"
  cluster_name          = local.cluster_name
  es_version            = local.es_version
  namespace             = "storage"
  replicas              = 2
  master_eligible_nodes = local.master_eligible_nodes
  storage_class_name    = kubernetes_storage_class.es_ssd.metadata[0].name
  storage_size          = "40Gi"

  common_annotations = {
    "janitor/ttl" = "10000d",
  }
}

output "elasticsearch_endpoint" {
  value = module.elasticsearch_master.elasticsearch_endpoint
}
```

### Variables

In order to check which variables are customizable, check `variables.tf`.
