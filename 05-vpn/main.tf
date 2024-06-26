resource "aws_key_pair" "vpn" {
  key_name = "openvpn"
  #   public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWCt9wx55HC645+yiXyb4m1hKiNmDQsdt1Kgw0Qyup8 ACER@DESKTOP-UDFTBDS"
  public_key = file("~/.ssh/openvpn.pub")
}

module "vpn" {
  source   = "terraform-aws-modules/ec2-instance/aws"
  key_name = aws_key_pair.vpn.key_name
  name     = "${var.project_name}-${var.env}-vpn"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  subnet_id              = local.public_subnet_id
  ami                    = data.aws_ami.ami_id.id
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.env}-vpn"
    }
  )
}
