terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6.2"
    }
  }
}

resource "docker_image" "nginx" {
  name = var.container_image
}

resource "docker_container" "nginx-container" {

  count = var.container_count
  privileged = var.container_privileged
  memory    = var.container_memory
  image = docker_image.nginx.image_id
  name  = "${var.container_name}-${count.index + 1}"
  
  ports {
    internal = 80
    external = var.container_ports + count.index
  }

  upload {
    content = templatefile("${path.module}/index.html.tpl", { HOSTNAME = "${self.name}" })
    file = "/usr/share/nginx/html/index.html"
  }

  env = {
    HOSTNAME = self.name
  }
}