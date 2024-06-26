resource "aws_ssm_parameter" "web_alb_listener_arn" {
  name  = "/${var.project_name}/${var.env}/web_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.http.arn
  //overwrite = true

}

resource "aws_ssm_parameter" "web_alb_listener_arn_https" {
  name  = "/${var.project_name}/${var.env}/web_alb_listener_arn_https"
  type  = "String"
  value = aws_lb_listener.https.arn
  //overwrite = true

}