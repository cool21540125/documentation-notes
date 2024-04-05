terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_network" "net_devops" {
  name   = "net_devops"
  driver = "bridge"
  ipam_config {
    subnet  = "10.90.90.0/24"
    gateway = "10.90.90.1"
  }
}

resource "docker_network" "net_app" {
  name   = "net_app"
  driver = "bridge"
  ipam_config {
    subnet  = "10.80.80.0/24"
    gateway = "10.80.80.1"
  }
}
