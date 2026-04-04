#!/bin/bash

# Delete all Kubernetes namespaces
kubectl delete ns --all

# Uninstall all Helm charts
helm ls --short | xargs -n1 helm uninstall

# Destroy Terraform AWS infrastructure
cd path/to/your/terraform/directory
terraform destroy -auto-approve
