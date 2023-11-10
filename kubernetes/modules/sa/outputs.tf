output "name" {
  value = yandex_iam_service_account.service_account.name
}

output "id" {
  value = data.yandex_iam_service_account.service_account.service_account_id
}
