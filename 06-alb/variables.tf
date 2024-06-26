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
        Component = "alb"
    }
}

variable "zone_name" {
  default = "surisetty.online"
}