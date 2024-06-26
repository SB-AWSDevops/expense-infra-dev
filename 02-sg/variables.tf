variable "project_name"{
    default = "expense"
}

variable "env"{
    default = "dev"
}

variable "common_tags"{
    default = {
        Project = "expense"
        Env = "dev"
        Terraform = "true"
    }
}

variable "db_sg_description"{
    default = "Security Group for DB MYSQL Instances"
}

variable "backend_sg_description"{
     default = "Security Group for Backend Instances"
}
variable "frontend_sg_description"{
     default = "Security Group for Frontend Instances"
}
variable "bastion_sg_description"{
     default = "Security Group for Bastion Instances"
}
variable "alb_sg_description"{
     default = "Security Group for ALB Instances"
}
variable "vpn_sg_description"{
     default = "Security Group for VPN Instances"
}
variable "web_alb_sg_description"{
     default = "Security Group for web_alb Instances"
}

variable "sg_name"{
    default = "db"
}

variable "sg_tags"{
    default = {
        Name = "sg"
    }
}

variable "vpn_sg_rules" {
  default = [
    {
        from_port = 943
        to_port = 943
        protocol = "tcp" 
        allowed_cidr = ["0.0.0.0/0"]
    },
    {
        from_port = 443
        to_port = 443
        protocol = "tcp" 
        allowed_cidr = ["0.0.0.0/0"]
    },
    {
        from_port = 22
        to_port = 22
        protocol = "tcp" 
        allowed_cidr = ["0.0.0.0/0"]
    },
    {
        from_port = 1194
        to_port = 1194
        protocol = "udp" 
        allowed_cidr = ["0.0.0.0/0"]
    }
  ]
}