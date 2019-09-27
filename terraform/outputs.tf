output "kubeconfig" {
  value = data.template_file.kubeconfig.rendered
  sensitive = true
}

output "github_actions_key" {
  value = google_service_account_key.github_actions.private_key
  sensitive = true
}
