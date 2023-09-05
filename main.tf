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
  image             = "ghcr.io/moisesjurad0/scrapper-1:51"
  must_run          = true
  publish_all_ports = true
  command = [
    "tail",
    "-f",
    "/dev/null"
  ]

  # port_bindings {
  #   container_port = 80
  #   host_port      = 8080
  # }
}

# environment = {
#   VAR1 = "valor1",
#   VAR2 = "valor2",
#   # Añade aquí las variables de entorno que desees inyectar
# }

# ports {
#   internal = 22
#   external = 2222
# }

# export {
#   name  = "SSH_PORT"
#   value = 2222
# }
# }
