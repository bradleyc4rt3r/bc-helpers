# Common Prefix 
locals {
  project_prefix = "${var.project}-${var.environment}-${var.region_code[var.region]}"
}
