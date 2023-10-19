provider "yandex" {
  version                  = ">= 0.35.0"
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone

  # Not used here:
  # token     = ""
}
