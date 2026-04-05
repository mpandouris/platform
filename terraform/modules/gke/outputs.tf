
# Output variables for Terraform
output "namespaces" {
  description = "List namespaces created"
  value = [for ns in kubernetes_namespace_v1.envs : ns.metadata[0].name]
}