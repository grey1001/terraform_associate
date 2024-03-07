variable "azs" {
  type    = list(string)
  default = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
}


variable "public_subnet_tags_per_az" {
  type = map(map(string))
  default = {
    "eu-west-3a" = {
      "Environment"                        = "Production"
      "Owner"                              = "Creative"
      "Name"                               = "Eks_subnet1-public-eu-west-3a"
      "kubernetes.io/cluster/eks-cluster-terraform" = "owned"

      "kubernetes.io/role/elb"             = ""
    }
    "eu-west-3b" = {
      "Environment"                        = "Production"
      "Owner"                              = "Creative"
      "Name"                               = "Eks_subnet2-public-eu-west-3b"
      "kubernetes.io/cluster/eks-cluster-terraform" = "owned"

      "kubernetes.io/role/elb"             = ""
    }
    "eu-west-3c" = {
      "Environment"                        = "Production"
      "Owner"                              = "Creative"
      "Name"                               = "Eks_subnet3-public-eu-west-3c"
      "kubernetes.io/cluster/eks-cluster-terraform" = "owned"

      "kubernetes.io/role/elb"             = ""
    }
  }
}
variable "private_subnet_tags_per_az" {
  type = map(map(string))
  default = {
    "eu-west-3a" = {
      "Environment"                        = "Production"
      "Owner"                              = "Creative"
      "Name"                               = "Eks_subnet1-private-eu-west-3a"
      "kubernetes.io/cluster/eks-cluster-terraform" = "owned"

      "kubernetes.io/role/internal-elb"    = "1"
    }
    "eu-west-3b" = {
      "Environment"                        = "Production"
      "Owner"                              = "Creative"
      "Name"                               = "Eks_subnet2-private-eu-west-3b"
      "kubernetes.io/cluster/eks-cluster-terraform" = "owned"

      "kubernetes.io/role/internal-elb"    = "1"
    }
    "eu-west-3c" = {
      "Environment"                        = "Production"
      "Owner"                              = "Creative"
      "Name"                               = "Eks_subnet3-private-eu-west-3c"
      "kubernetes.io/cluster/eks-cluster-terraform" = "owned"

      "kubernetes.io/role/internal-elb"    = "1"
    }
  }
}
variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"] # Adjusted to fit within 10.1.0.0/16
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"] # Adjusted to fit within 10.1.0.0/16
}
variable "aws_region" {
  type    = string
  default = "eu-west-3"
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
    "Name" = "EKS_CLUSTER_VPC"
  }
}

variable "cluster_name" {
  type    = string
  default = "eks-primary-cluster-terraform"
}