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

variable "alb_log_user" {
  type = map
  default = {
    us-east-1      = 127311923021 #US East (N. Virginia)
    us-east-2      = 033677994240 #US East (Ohio)
    us-west-1      = 027434742980 #US West (N. California)
    us-west-2      = 797873946194 #US West (Oregon)
    ca-central-1   = 985666609251 #Canada (Central)
    eu-central-1   = 054676820928 #Europe (Frankfurt)
    eu-west-1      = 156460612806 #Europe (Ireland)
    eu-west-2      = 652711504416 #Europe (London)
    eu-west-3      = 009996457667 #Europe (Paris)
    eu-north-1     = 897822967062 #Europe (Stockholm)
    ap-east-1      = 754344448648 #Asia Pacific (Hong Kong)
    ap-northeast-1 = 582318560864 #Asia Pacific (Tokyo)
    ap-northeast-2 = 600734575887 #Asia Pacific (Seoul)
    ap-northeast-3 = 383597477331 #Asia Pacific (Osaka-Local)
    ap-southeast-1 = 114774131450 #Asia Pacific (Singapore)
    ap-southeast-2 = 783225319266 #Asia Pacific (Sydney)
    ap-south-1     = 718504428378 #Asia Pacific (Mumbai)
    me-south-1     = 076674570225 #Middle East (Bahrain)
    sa-east-1      = 507241528517 #South America (São Paulo)
    us-gov-west-1  = 048591011584 #AWS GovCloud (US-West)
    us-gov-east-1  = 190560391635 #AWS GovCloud (US-East)
    cn-north-1     = 638102146993 #China (Beijing)
    cn-northwest-1 = 037604701340 #China (Ningxia)
  }
}
#var.alb_log_user[var.region]
