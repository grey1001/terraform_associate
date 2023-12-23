variable "vpc_cidr" {
  type = string
}
variable "vpc_tags" {
  type = map(string)
}
variable "igw_tags" {
  type = map(string)
}

variable "subnet_tags" {
  type = map(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}
variable "vpc_rt_tags" {
  type = map(string)
}