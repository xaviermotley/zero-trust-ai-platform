terraform {
  required_version = ">= 1.3.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Install SPIRE using a module (example reference)
module "spire" {
  source      = "github.com/spiffe/spire-packages//deployments/k8s?ref=v1.7.1"
  trust_domain = "example.org"
}

# Install Kyverno using Helm
resource "helm_release" "kyverno" {
  name            = "kyverno"
  repository      = "https://kyverno.github.io/kyverno/"
  chart           = "kyverno"
  namespace       = "kyverno"
  create_namespace = true
  values          = [file("${path.module}/helm/values-kyverno.yaml")]
}

# Install OpenTelemetry Collector using Helm
resource "helm_release" "otel_collector" {
  name            = "otel-collector"
  repository      = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart           = "opentelemetry-collector"
  namespace       = "observability"
  create_namespace = true
  values          = [file("${path.module}/helm/values-otel.yaml")]
}
