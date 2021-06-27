variable "alb_log_user" {
  type = map
  default = {
    us-east-1      = "127311923021" #US East (N. Virginia)
    us-east-2      = "033677994240" #US East (Ohio)
    us-west-1      = "027434742980" #US West (N. California)
    us-west-2      = "797873946194" #US West (Oregon)
    ca-central-1   = "985666609251" #Canada (Central)
    eu-central-1   = "054676820928" #Europe (Frankfurt)
    eu-west-1      = "156460612806" #Europe (Ireland)
    eu-west-2      = "652711504416" #Europe (London)
    eu-west-3      = "009996457667" #Europe (Paris)
    eu-north-1     = "897822967062" #Europe (Stockholm)
    ap-east-1      = "754344448648" #Asia Pacific (Hong Kong)
    sa-east-1      = "507241528517" #South America (São Paulo)
    ap-south-1     = "718504428378" #Asia Pacific (Mumbai)
    me-south-1     = "076674570225" #Middle East (Bahrain)
    cn-north-1     = "638102146993" #China (Beijing)
    us-gov-west-1  = "048591011584" #AWS GovCloud (US-West)
    us-gov-east-1  = "190560391635" #AWS GovCloud (US-East)
    ap-northeast-1 = "582318560864" #Asia Pacific (Tokyo)
    ap-northeast-2 = "600734575887" #Asia Pacific (Seoul)
    ap-northeast-3 = "383597477331" #Asia Pacific (Osaka-Local)
    ap-southeast-1 = "114774131450" #Asia Pacific (Singapore)
    ap-southeast-2 = "783225319266" #Asia Pacific (Sydney)
    cn-northwest-1 = "037604701340" #China (Ningxia)
  }
}
#var.alb_log_user[var.region]
