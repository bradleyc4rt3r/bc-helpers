variable "region_code" {
  type = map
  default = {
    us-east-2      = "oh" # Ohio
    us-east-1      = "va" # US East (N. Virginia)
    us-west-1      = "ca" # N. California
    us-west-2      = "or" # US West (Oregon)
    ap-east-1      = "hk" # Hong Kong
    ap-south-1     = "mb" # Asia Pacific (Mumbai)
    ap-northeast-3 = "os" # Osaka-Local
    ap-northeast-2 = "se" # Asia Pacific (Seoul)
    ap-southeast-1 = "sg" # Singapore
    ap-southeast-2 = "sd" # Asia Pacific (Sydney)
    ap-northeast-1 = "tk" # Tokyo
    ca-central-1   = "cn" # Canada (Central)
    eu-central-1   = "ff" # Frankfurt
    eu-west-1      = "ie" # Europe (Ireland)
    eu-west-2      = "ld" # London
    eu-west-3      = "pr" # Europe (Paris)
    eu-north-1     = "st" # Stockholm
    me-south-1     = "bh" # Middle East (Bahrain)
    sa-east-1      = "sp" # São Paulo
  }
}
#var.region_code[var.region]
