terraform {
  required_version = ">= 1.1.6"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.87.0"
    }
  }

  backend "s3" {
    endpoint                    = "storage.yandexcloud.net"
    bucket                      = "s3-otus-devops-microservices-tfstate"
    region                      = "ru-central1-a"
    key                         = "terraform/otus-devops-microservices.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
