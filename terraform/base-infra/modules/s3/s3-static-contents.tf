#####
# S3 Bucket
#####

# ##  S3 bucket for static-contents
# resource "aws_s3_bucket" "static_contents" {
#   bucket = "${var.project_prefix}-s3-static-contents"
#   acl    = "private"
#   versioning {
#     enabled = true
#   }

#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         sse_algorithm = "AES256"
#       }
#     }
#   }

#   tags = {
#     Name        = "${var.project_prefix}-s3-static-contents"
#     environment = var.environment
#     CreatedBy   = "Terraform"
#   }

# }

# resource "aws_s3_bucket_public_access_block" "static_contents" {
#   bucket = aws_s3_bucket.static_contents.id

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true

# }
