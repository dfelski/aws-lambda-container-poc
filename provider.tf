# Provider and access details

provider "aws" {
  # credentials have to be be provided via environment variables
  # AWS_ACCESS_KEY_ID: <access key>
  # AWS_SECRET_ACCESS_KEY: <secret key>
  region = "eu-west-1"
  profile = "<PROFILE_NAME"
  assume_role {
    role_arn     = "<ROLE_ARN>"
    session_name = "lambda_test"
  }
}
