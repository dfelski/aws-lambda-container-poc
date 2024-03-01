terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0"
    }  
  }
}
