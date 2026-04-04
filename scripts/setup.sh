#!/bin/bash

# Script to initialize Terraform, deploy EKS cluster, configure kubectl, install Prometheus, and Cluster Autoscaler, and deploy Node.js application

set -e

# Initialize Terraform
printf "Initializing Terraform...\n"
tf init

# Plan and apply Terraform configuration to create EKS cluster
printf "Planning Terraform deployment...\n"
tf plan
tf apply -auto-approve

# Update kubeconfig to use the EKS cluster
echo "Updating kubeconfig..."
aws eks --region us-west-2 update-kubeconfig --name <EKS_CLUSTER_NAME>

# Verify kubectl context
kubectl config get-contexts

# Install Helm
printf "Installing Helm...\n"
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Add Prometheus Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install Prometheus
echo "Installing Prometheus..."
helm install prometheus prometheus-community/prometheus

# Install Cluster Autoscaler
printf "Installing Cluster Autoscaler...\n"
helm repo add autoscaler https://kubernetes.github.io/autoscaler
helm repo update

# Deploy Cluster Autoscaler for EKS
echo "Deploying Cluster Autoscaler..."
helm install cluster-autoscaler autoscaler/cluster-autoscaler --set autoDiscovery.clusterName=<EKS_CLUSTER_NAME>

# Deploy Node.js application
printf "Deploying Node.js application...\n"
kubectl apply -f deployment.yaml
