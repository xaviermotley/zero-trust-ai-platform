variable "cluster_name" {
  description = "Name of the Kubernetes cluster."
  type        = string
  default     = "zero-trust-ai-cluster"
}

variable "region" {
  description = "Cloud region for cluster."
  type        = string
  default     = "us-west1"
}

variable "trust_domain" {
  description = "SPIFFE trust domain"
  type        = string
  default     = "example.org"
}
