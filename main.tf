terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "nginx-container" {
  image = docker_image.nginx.image_id
  name  = "nginx-container"
  ports {
    internal = 80
    external = 8080
  }
}