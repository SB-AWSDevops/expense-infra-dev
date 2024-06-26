locals {
  private_subnet_id_slice = slice(split(",", data.aws_ssm_parameter.private_subnet_ids.value), 0, 1)
  private_subnet_id       = join("", local.private_subnet_id_slice)
}
