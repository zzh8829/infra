resource "google_service_account" "github_actions" {
  account_id = "github-actions"
  display_name = "Github Actions"
}

resource "google_service_account_key" "github_actions" {
  service_account_id = "${google_service_account.github_actions.name}"
}

resource "google_project_iam_member" "github_actions_gke" {
  project = "${var.project}"
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}
