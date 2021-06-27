provider "aws" {
  region  = var.region
  profile = "${var.project}-${var.environment}"

  assume_role {
    role_arn     = "arn:aws:iam::${var.account_id}:role/${var.assume_role}"
    session_name = "terraform-assume-role"
    external_id  = var.external_id
  }

  ignore_tags {
    key_prefixes = ["kubernetes.io/"]
  }
}
