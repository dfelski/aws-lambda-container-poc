{
  "Version": "2012-10-17",
  "Id" : "S3 Bucket policy",
  "Statement": [
    {
      "Sid": "DockerImageImportLambda",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${BUCKET_NAME}",
        "arn:aws:s3:::${BUCKET_NAME}/*"
      ],
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      }
    }
  ]
}
