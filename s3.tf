# S3 bucket to store data
resource "aws_s3_bucket" "docker_image_import" {
  bucket = "docker-image-import"
  force_destroy = true
  tags = {
    Name = "docker-image-import"
  }
}

resource "aws_s3_bucket_public_access_block" "docker_image_import" {
  bucket = aws_s3_bucket.docker_image_import.id

  block_public_acls       = false
  block_public_policy     = true
  ignore_public_acls      = false
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "docker_image_import" {
  bucket = aws_s3_bucket.docker_image_import.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_policy" "docker_image_import" {
  bucket = aws_s3_bucket.docker_image_import.id

  policy = templatefile("${path.module}/s3_policy.tpl", {
    BUCKET_NAME = "docker-image-import",
  })
}
