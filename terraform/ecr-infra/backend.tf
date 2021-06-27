# Backend 
terraform {
  backend "s3" {
    bucket                  = ""
    key                     = ""
    workspace_key_prefix    = ""
    region                  = "us-east-1"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = ""
  }
}
