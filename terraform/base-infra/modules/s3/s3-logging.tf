#####
# S3 Bucket
#####

##  S3 bucket for logging
resource "aws_s3_bucket" "logging" {
  bucket = "${var.project_prefix}-s3-infra-logs"
  acl    = "private"
  policy = data.template_file.logging_bucket_policy.rendered

  versioning {
    enabled = true
  }

  # lifecycle {
  #   prevent_destroy = true
  # }

  lifecycle_rule {
    enabled = true
    prefix  = "${var.project_prefix}-vpc-flow-log/"

    expiration {
      days = 365
    }

    noncurrent_version_expiration {
      days = 365
    }
  }

  lifecycle_rule {
    enabled = true
    prefix  = "${var.project_prefix}-cloudtrail/"

    expiration {
      days = 365
    }

    noncurrent_version_expiration {
      days = 365
    }
  }

  lifecycle_rule {
    enabled = true
    prefix  = "${var.project_prefix}-aws-config/"

    expiration {
      days = 365
    }

    noncurrent_version_expiration {
      days = 365
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "${var.project_prefix}-s3-infra-logs"
    environment = var.environment
    CreatedBy   = "Terraform"
  }

}

resource "aws_s3_bucket_public_access_block" "logging" {
  bucket = aws_s3_bucket.logging.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

data "template_file" "logging_bucket_policy" {
  template = file("${path.module}/templates/logging-bucket-policy.json", )
  vars = {
    account_id               = var.account_id
    alb_aws_account_id       = var.alb_log_user[var.region]
    bucket_name              = "${var.project_prefix}-s3-infra-logs"
    s3_key_prefix_vpcflow    = "${var.project_prefix}-vpc-flow-log"
    s3_key_prefix_cloudtrail = "${var.project_prefix}-cloudtrail"
    s3_key_prefix_aws_config = "${var.project_prefix}-aws-config"
  }
}
