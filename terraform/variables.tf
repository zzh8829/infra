variable "project" {
  type = "string"
  description = "Google Cloud project name"
  default = "gcloud-zihao"
}

variable "region" {
  type = "string"
  description = "Default Google Cloud region"
  default = "us-west1"
}

variable "name" {
  type = "string"
  description = "terraform stack name"
  default = "zz"
}
