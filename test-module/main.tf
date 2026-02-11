provider "docker" {
  host = "unix:///var/run/docker.sock"
}

module "nginx" {
    source = "git::https://github.com/Xamez/Terraform-Lab.git"
    container_count = 3
}