resource "aws_iam_role" "lambda_role" {
    name   = "Docker_Image_Import_Role"
    assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
 name         = "aws_iam_policy_for_terraform_aws_lambda_role"
 path         = "/"
 description  = "AWS IAM Policy for managing aws lambda role"
 policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   },
   {
     "Action": [
       "s3:PutObject"
     ],
     "Resource": "arn:aws:s3:::*",
     "Effect": "Allow"
   }   
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}

resource "aws_lambda_function" "docker_image_import" {
    image_uri                      = docker_image.lambda_function_container.name
    function_name                  = "Docker_Image_Import"
    package_type                   = "Image"
    role                           = aws_iam_role.lambda_role.arn
    timeout                        =  "600"

    ephemeral_storage {
      size = 4096 # Min 512 MB and the Max 10240 MB
    }

    depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role, docker_registry_image.lambda_function_container]
}

