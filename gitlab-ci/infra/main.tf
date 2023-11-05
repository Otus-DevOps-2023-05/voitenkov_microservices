locals {
  cidr_internet = "0.0.0.0/0" # All IPv4 addresses.
}

resource "yandex_vpc_network" "network-otus-devops-microservices" {
  name                        = "network-${var.project}-${var.environment}"
}


resource "yandex_vpc_subnet" "subnet-otus-devops-microservices-a1" {
  folder_id      =  var.folder_id
  name           = "subnet-${var.project}-${var.environment}-a1"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-otus-devops-microservices.id

  depends_on = [
    yandex_vpc_network.network-otus-devops-microservices,
  ]

}

resource "yandex_vpc_security_group" "sg-otus-devops-microservices-instance-linux" {
  description = "Default security group for linux instances"
  name        = "sg-${var.project}-${var.environment}-instance-linux"
  network_id  = yandex_vpc_network.network-otus-devops-microservices.id


  egress {
    description    = "Allow any outgoing traffic to the Internet"
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = [local.cidr_internet]
  }
  ingress {
    description    = "Allow SSH connections to the instance"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = [local.cidr_internet]
  }

  depends_on = [yandex_vpc_network.network-otus-devops-microservices]
}

resource "yandex_vpc_security_group" "sg-otus-devops-microservices-instance-gitlab" {
  description = "Default security group for GitLab instances"
  name        = "sg-${var.project}-${var.environment}-instance-gitlab"
  network_id  = yandex_vpc_network.network-otus-devops-microservices.id

  ingress {
    description    = "Allow HTTP connections to the instance"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = [local.cidr_internet]
  }

  depends_on = [yandex_vpc_network.network-otus-devops-microservices]
}

module "instance-sa" {
  source                      = "../modules/sa"
  sa_name                     = "sa-${var.project}-${var.environment}-instance"
  sa_description              = "Service account for compute instances in ${var.project} ${var.environment} environment"
  sa_folder_id                = var.folder_id
  sa_role                     = "viewer"
}

resource "yandex_vpc_address" "ip-otus-devops-microservices-gitlab" {
  name = "ip-${var.project}-${var.environment}-gitlab"

  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
  depends_on = [
    yandex_vpc_subnet.subnet-otus-devops-microservices-a1,
  ]
}

module "gitlab-instance" {
  source                        = "../modules/instance"
  instance_name                 = "gitlab"
  instance_project              = var.project
  instance_environment          = var.environment
  instance_service_account_name = module.instance-sa.name
  instance_preemptible          = true
  instance_cores                = 8
  instance_memory               = 8
  instance_disk_size            = 50
  instance_subnet_id            = yandex_vpc_subnet.subnet-otus-devops-microservices-a1.id
  instance_nat                  = true
  instance_security_group_ids   = [
    yandex_vpc_security_group.sg-otus-devops-microservices-instance-linux.id,
    yandex_vpc_security_group.sg-otus-devops-microservices-instance-gitlab.id,
  ]
  instance_nat_ip_address       = yandex_vpc_address.ip-otus-devops-microservices-gitlab.external_ipv4_address.0.address
  instance_user_data_file       = "ubuntu-devops"
  instance_public_key           = "yc.pub"
  instance_serial_port_enable   = 1
  instance_image_id             = "fd81n0sfjm6d5nq6l05g" # ubuntu-20-04-lts-v20230904

  depends_on = [
    module.instance-sa,
    yandex_vpc_security_group.sg-otus-devops-microservices-instance-linux,
    yandex_vpc_security_group.sg-otus-devops-microservices-instance-gitlab,
    yandex_vpc_address.ip-otus-devops-microservices-gitlab,
  ]
}
