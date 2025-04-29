terraform {
  required_providers {
    docker = {
      source  = "hashicorp/docker"
      version = "~> 3.0"
    }
  }
}
resource "docker_image" "postgres" {
  name = "postgres:15"
}

resource "docker_container" "postgres" {
  name  = "kestra_pg"
  image = docker_image.postgres.latest
  ports {
    internal = 5432
    external = 5432
  }
  env = [
    "POSTGRES_PASSWORD=${var.postgres_password}",
    "POSTGRES_DB=${var.postgres_db}",
    "POSTGRES_USER=${var.postgres_user}"
  ]
}

resource "docker_image" "minio" {
  name = "minio/minio"
}

resource "docker_container" "minio" {
  name  = "kestra_minio"
  image = docker_image.minio.latest
  ports {
    internal = 9000
    external = 9000
  }
  command = ["server", "/data"]
  env = [
    "MINIO_ROOT_USER=${var.minio_user}",
    "MINIO_ROOT_PASSWORD=${var.minio_password}"
  ]
}
