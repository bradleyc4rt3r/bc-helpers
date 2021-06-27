#####
# S3 bucket
#####

##  S3 bucket for artifactory
resource "aws_s3_bucket" "artifactory" {
  bucket = "${var.project_prefix}-s3-artifactory"
  acl    = "private"
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "${var.project_prefix}-s3-artifactory"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

  lifecycle {
    prevent_destroy = true
  }

}

resource "aws_s3_bucket_public_access_block" "artifactory" {
  bucket = aws_s3_bucket.artifactory.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}
