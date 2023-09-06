terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host = "npipe:////./pipe/docker_engine"
}

resource "docker_container" "scrapper" {
  name              = "scrapper"
  image             = "ghcr.io/moisesjurad0/scrapper-1:60"
  must_run          = true
  publish_all_ports = true
  command = [
    "tail",
    "-f",
    "/dev/null"
  ]

  # env_file          = "./.env"
  # env = ["SERVICE=elastic", "PROJECT=stage", "ENVIRONMENT=operations"]
  # env = var.container_env
  env = [
    for key, value in var.container_env :
    "${key}=${value}"
  ]

  # dynamic "env" {
  #   for_each = var.container_env
  #   content {
  #     name  = env.key
  #     value = env.value
  #   }
  # }

  # port_bindings {
  #   container_port = 80
  #   host_port      = 8080
  # }

  # ports {
  #   internal = 22
  #   external = 2222
  # }

  # export {
  #   name  = "SSH_PORT"
  #   value = 2222
  # }
}

# environment = {
#   VAR1 = "valor1",
#   VAR2 = "valor2",
#   # Añade aquí las variables de entorno que desees inyectar
# }

