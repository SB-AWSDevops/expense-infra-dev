module "db" {
  //source         = "../../expense-dev-sg"
  source         = "git::https://github.com/SB-AWSDevops/expense-dev-sg"
  project_name   = var.project_name
  env            = var.env
  sg_description = var.db_sg_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  common_tags    = var.common_tags
  sg_name        = "db"
}

module "backend" {
  source         = "git::https://github.com/SB-AWSDevops/expense-dev-sg"
  project_name   = var.project_name
  env            = var.env
  sg_description = var.backend_sg_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  common_tags    = var.common_tags
  sg_name        = "backend"
}

module "frontend" {
  source         = "git::https://github.com/SB-AWSDevops/expense-dev-sg"
  project_name   = var.project_name
  env            = var.env
  sg_description = var.frontend_sg_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  common_tags    = var.common_tags
  sg_name        = "frontend"
}

# module "bastion" {
#   source         = "git::https://github.com/SB-AWSDevops/expense-dev-sg"
#   project_name   = var.project_name
#   env            = var.env
#   sg_description = var.bastion_sg_description
#   vpc_id         = data.aws_ssm_parameter.vpc_id.value
#   common_tags    = var.common_tags
#   sg_name        = "bastion"
# }

module "alb" {
  source         = "git::https://github.com/SB-AWSDevops/expense-dev-sg"
  project_name   = var.project_name
  env            = var.env
  sg_description = var.alb_sg_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  common_tags    = var.common_tags
  sg_name        = "alb"
}

module "vpn" {
  source         = "git::https://github.com/SB-AWSDevops/expense-dev-sg"
  project_name   = var.project_name
  env            = var.env
  sg_description = var.vpn_sg_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  common_tags    = var.common_tags
  sg_name        = "vpn"
  inbound_rules  = var.vpn_sg_rules
}

module "web_alb" {
  source         = "git::https://github.com/SB-AWSDevops/expense-dev-sg"
  project_name   = var.project_name
  env            = var.env
  sg_description = var.web_alb_sg_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  common_tags    = var.common_tags
  sg_name        = "web_alb"
}


# db accepts the backend connection
resource "aws_security_group_rule" "db_backend" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.backend.sg_id
  security_group_id        = module.db.sg_id
}
# # db accepts the bastion connection/traffic
# resource "aws_security_group_rule" "db_bastion" {
#   type                     = "ingress"
#   from_port                = 3306
#   to_port                  = 3306
#   protocol                 = "tcp"
#   source_security_group_id = module.bastion.sg_id
#   security_group_id        = module.db.sg_id
# }
# db accepts the vpn connection/traffic
resource "aws_security_group_rule" "db_vpn" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.db.sg_id
}
# backend accepts the alb connection
resource "aws_security_group_rule" "backend_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.alb.sg_id
  security_group_id        = module.backend.sg_id
}

# # backend accepts the bastion connection
# resource "aws_security_group_rule" "backend_bastion" {
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   source_security_group_id = module.bastion.sg_id
#   security_group_id        = module.backend.sg_id
# }

# backend accepts the vpn connection
resource "aws_security_group_rule" "backend_vpn_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.backend.sg_id
}

# backend accepts the vpn connection
resource "aws_security_group_rule" "backend_vpn_http" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.backend.sg_id
}


# frontend accepts the public traffic
resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.frontend.sg_id
}

# frontend accepts the vpn traffic
resource "aws_security_group_rule" "frontend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from
  security_group_id = module.frontend.sg_id
}

# frontend accepts the vpn traffic
resource "aws_security_group_rule" "frontend_web_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_alb.sg_id # source is where you are getting traffic from
  security_group_id = module.frontend.sg_id
}

# # frontend accepts the bastion traffic
# resource "aws_security_group_rule" "frontend_bastion" {
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   source_security_group_id = module.bastion.sg_id
#   security_group_id        = module.frontend.sg_id
# }


# # bastion accepts the public traffic
# resource "aws_security_group_rule" "bastion_public" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = module.bastion.sg_id
# }

# balb accepts the vpn traffic
resource "aws_security_group_rule" "alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.alb.sg_id
}

# backend alb accepts the frontend traffic
resource "aws_security_group_rule" "alb_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id = module.alb.sg_id
}

# web_alb accepts the public traffic
resource "aws_security_group_rule" "web_alb_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.web_alb.sg_id
}

# web_alb accepts the public traffic from https protocol
resource "aws_security_group_rule" "web_alb_public_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.web_alb.sg_id
}
# added as part of jenkins ci/cd
resource "aws_security_group_rule" "backend_default_vpc" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["172.31.0.0/16"]
  security_group_id = module.backend.sg_id
}