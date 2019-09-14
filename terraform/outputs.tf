output "kubeconfig" {
  value = data.template_file.kubeconfig.rendered
  sensitive = true
}
