variable "azs" {
  type    = list(string)
  default = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
}

variable "az_map" {
  type = map(string)
  default = {
    "10.0.1.0/24" = "eu-west-3a",
    "10.0.2.0/24" = "eu-west-3b",
    "10.0.3.0/24" = "eu-west-3c",

  }
}

variable "public_subnet_tags_per_az" {
  type = map(map(string))
  default = {
    "eu-west-3a" = {
      "Environment" = "Production"
      "Owner"       = "Creative"
      "Name"        = "Prod_subnet1-public-eu-west-3a"
    }
    "eu-west-3b" = {
      "Environment" = "Production"
      "Owner"       = "Creative"
      "Name"        = "Prod_subnet2-public-eu-west-3b"
    }
    "eu-west-3c" = {
      "Environment" = "Production"
      "Owner"       = "Creative"
      "Name"        = "Prod_subnet3-public-eu-west-3c"
    }
  }
}
variable "private_subnet_tags_per_az" {
  type = map(map(string))
  default = {
    "eu-west-3a" = {
      "Environment" = "Production"
      "Owner"       = "Creative"
      "Name"        = "Prod_subnet1-private-eu-west-3a"
    }
    "eu-west-3b" = {
      "Environment" = "Production"
      "Owner"       = "Creative"
      "Name"        = "Prod_subnet2-private-eu-west-3b"
    }
    "eu-west-3c" = {
      "Environment" = "Production"
      "Owner"       = "Creative"
      "Name"        = "Prod_subnet3-private-eu-west-3c"
    }
  }
}
variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]

}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]

}

variable "tags" {
  type = map(string)
  default = {
    "Owner"       = "Prod-team"
    "Environment" = "Production"
  }
}

variable "vpc_tags" {
  type = map(string)
  default = {
    "Name" = "PRODUCTION_VPC"
  }
}

variable "ingress_rules" {
  type = list(string)
  default = ["ssh-tcp", "http-80-tcp","http-8080-tcp","https-443-tcp","https-8443-tcp"]
}
