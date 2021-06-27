#####
# Load Balancer Listener
#####

resource "aws_lb_listener" "alb_listener_80" {
  load_balancer_arn = aws_lb.ec2_artifactory_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "alb_listener_443" {
  load_balancer_arn = aws_lb.ec2_artifactory_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_artifactory_tg.arn
  }
}

# resource "aws_lb_listener" "alb_listener_8081" {
#   load_balancer_arn = aws_lb.ec2_artifactory_alb.arn
#   port              = "8081"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.ec2_artifactory_tg.arn
#   }
# }
