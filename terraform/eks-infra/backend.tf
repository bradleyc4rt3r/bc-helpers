# Backend 
terraform {
  backend "s3" {
    bucket                  = "devops-terraform-states-1" #new terraform-states-2021
    key                     = "jenkins-app-infra.state"
    workspace_key_prefix    = "jenkins-app-infra"
    region                  = "us-east-1"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "devops-starter"
  }
}
