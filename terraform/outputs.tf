output "cluster_id" {
  value = "<your_cluster_id>"
}

output "endpoint" {
  value = "<your_endpoint>"
}

output "security_group_ids" {
  value = "<your_security_group_ids>"
}

output "iam_role_arn" {
  value = "<your_iam_role_arn>"
}

output "kubectl_config_command" {
  value = "aws eks update-kubeconfig --name <your_cluster_name> --region <your_region>"
}