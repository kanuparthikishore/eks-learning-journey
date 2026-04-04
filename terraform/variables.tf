# Terraform Variables

variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "The version of Kubernetes"
  type        = string
}

variable "environment" {
  description = "The environment (e.g. dev, prod)"
  type        = string
}

variable "common_tags" {
  description = "Common tags for resources"
  type        = map(string)
}