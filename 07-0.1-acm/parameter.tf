resource "aws_ssm_parameter" "acm_certificate_arn" {
  name  = "/${var.project_name}/${var.env}/acm_certificate_arn"
  type  = "String"
  value = aws_acm_certificate.expense.arn
  //overwrite = true

}