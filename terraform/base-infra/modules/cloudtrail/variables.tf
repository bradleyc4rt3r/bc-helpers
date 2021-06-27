##  Common Variables
variable "project_prefix" {
  description = "Specify the project prefix"
}

variable "environment" {
  description = "Specify the environment - dev/stg/prod"
}

##  S3 bucket - logging
variable "logging_s3" {
  description = "The S3 logging bucket ID"
}
