variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}


variable "public_subnet_tags_per_az" {
  type = map(map(string))
  default = {
    "us-east-1a" = {
      "Environment"                        = "Production"
      "Owner"                              = "Creative"
      "Name"                               = "Eks_subnet1-public-us-east-1a"
      "kubernetes.io/cluster/eks-cluster-terraform" = "owned"

      "kubernetes.io/role/elb"             = ""
    }
    "us-east-1b" = {
      "Environment"                        = "Production"
      "Owner"                              = "Creative"
      "Name"                               = "Eks_subnet2-public-us-east-1b"
      "kubernetes.io/cluster/eks-cluster-terraform" = "owned"

      "kubernetes.io/role/elb"             = ""
    }
    "us-east-1c" = {
      "Environment"                        = "Production"
      "Owner"                              = "Creative"
      "Name"                               = "Eks_subnet3-public-us-east-1c"
      "kubernetes.io/cluster/eks-cluster-terraform" = "owned"

      "kubernetes.io/role/elb"             = ""
    }
  }
}
variable "private_subnet_tags_per_az" {
  type = map(map(string))
  default = {
    "us-east-1a" = {
      "Environment"                        = "Production"
      "Owner"                              = "Creative"
      "Name"                               = "Eks_subnet1-private-us-east-1a"
      "kubernetes.io/cluster/eks-cluster-terraform" = "owned"

      "kubernetes.io/role/internal-elb"    = "1"
    }
    "us-east-1b" = {
      "Environment"                        = "Production"
      "Owner"                              = "Creative"
      "Name"                               = "Eks_subnet2-private-us-east-1b"
      "kubernetes.io/cluster/eks-cluster-terraform" = "owned"

      "kubernetes.io/role/internal-elb"    = "1"
    }
    "us-east-1c" = {
      "Environment"                        = "Production"
      "Owner"                              = "Creative"
      "Name"                               = "Eks_subnet3-private-us-east-1c"
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
  default = ["10.0.16.0/24", "10.0.17.0/24", "10.0.18.0/24"] # Adjusted to fit within 10.1.0.0/16
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.32.0/24", "10.0.33.0/24", "10.0.34.0/24"] # Adjusted to fit within 10.1.0.0/16
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
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
  default = "eks-secondary-cluster-terraform"
}