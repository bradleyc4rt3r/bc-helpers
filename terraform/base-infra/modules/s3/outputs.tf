##  S3 bucket - logging
output "s3_logging_id" {
  value = aws_s3_bucket.logging.id
}

output "s3_logging_arn" {
  value = aws_s3_bucket.logging.arn
}
