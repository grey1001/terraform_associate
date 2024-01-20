variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "tags" {
  type = map(string)
  default = {
    "Name"  = "Prod_VPC"
    "Owner" = "Production"
  }
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
}
variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "subnet_cidr_az_map" {
  type        = map(string)
  description = "Map of subnet CIDR blocks to corresponding Availability Zones."
  default = {
    "10.0.1.0/24" = "eu-west-3a",
    "10.0.2.0/24" = "eu-west-3b",
    "10.0.3.0/24" = "eu-west-3c",
    # Add more mappings as needed
  }
}

variable "public_subnet_tags_per_az" {
  type    = map(map(string))
  default = {
    "eu-west-3a" = {
      "Environment" = "Production"
      "Tag1"        = "Value1"
    }
    "eu-west-3b" = {
      "Environment" = "Production"
      "Tag2"        = "Value2"
    }
    "eu-west-3c" = {
      "Environment" = "Production"
      "Tag3"        = "Value3"
    }
  }
}

variable "sg_ports" {
  type = list(number)
  default = [ 443, 3600, 8080, 9000, 22]  
}

