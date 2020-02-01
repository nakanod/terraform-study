provider "google" {
  credentials = file("~/.gcp_service_account.json")
  project = "project-id"
  region = "asia-northeast1"
}
