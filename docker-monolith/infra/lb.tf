resource "yandex_lb_network_load_balancer" "app-lb" {
  name                = "reddit-app-lb"

  listener {
    name        = "reddit-app-listener"
    port        = 80
    target_port = 9292
    protocol    = "tcp"
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_lb_target_group.app-target-group.id
    healthcheck {
      name                = "http-healthcheck"
      interval            = 2
      timeout             = 1
      unhealthy_threshold = 2
      healthy_threshold   = 2
      http_options {
        port = 9292
        path = "/"
      }
    }
  }
  depends_on = [
    yandex_lb_target_group.app-target-group
  ]
}

resource "yandex_lb_target_group" "app-target-group" {
  name = "reddit-app-target-group"

  dynamic "target" {
    for_each = yandex_compute_instance.app

    content {
      subnet_id = var.subnet_id
      address   = target.value.network_interface.0.ip_address
    }

  }

  depends_on = [
    yandex_compute_instance.app
  ]
}
