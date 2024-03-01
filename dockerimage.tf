resource "docker_image" "lambda_function_container" {
  name = "${aws_ecr_repository.lambda_function_container.repository_url}:latest"

  build {
    context = "docker"
    tag     = ["${aws_ecr_repository.lambda_function_container.repository_url}:latest"]
    label = {
      author : "test"
    }
  }  
}

resource "docker_registry_image" "lambda_function_container" {
  name = docker_image.lambda_function_container.name
  keep_remotely = true
}

data "aws_ecr_authorization_token" "ecr_token" {}

# configure docker provider
provider "docker" {
  registry_auth {
      address = data.aws_ecr_authorization_token.ecr_token.proxy_endpoint
      username = data.aws_ecr_authorization_token.ecr_token.user_name
      password  = data.aws_ecr_authorization_token.ecr_token.password
    }
}

resource "aws_ecr_repository" "lambda_function_container" {
  force_delete         = true
  name                 = "lambda-function"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "lambda-function"
  }
}
