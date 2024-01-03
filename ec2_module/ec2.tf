# main.tf

# main.tf

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"

  azs                        = var.azs
  cidr                       = var.cidr
  create_igw                 = true
  enable_dns_hostnames       = true
  enable_dns_support         = true
  map_public_ip_on_launch    = true
  public_subnets             = var.public_subnets
  private_subnets            = var.private_subnets
  public_subnet_tags_per_az  = var.public_subnet_tags_per_az
  private_subnet_tags_per_az = var.private_subnet_tags_per_az
  public_route_table_tags = merge(var.tags, {
    "Name" = "Prod_Public_RT"
  })
  igw_tags = merge(var.tags, {
    "Name" = "Prod-IGW"
  })
  vpc_tags = var.vpc_tags


}
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}


module "security-group" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "5.1.0"
  description         = "My test SG"
  use_name_prefix     = true
  name                = "Prod-SG"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_rules = var.ingress_rules
  egress_rules  = ["all-all"]
}

output "security_group_id" {
  value = module.security-group.security_group_id
}

# module "ec2-instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "5.6.0"
#   ami     = "ami-01d21b7be69801c2f"
#   count   = 3

#   name = "Prod_instance-${count.index}"

#   instance_type          = "t2.micro"
#   key_name               = "demo"
#   monitoring             = true
#   vpc_security_group_ids = [module.security-group.security_group_id]
#   subnet_id              = module.vpc.public_subnets[0]

# }
data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

module "eks" {
  source                                       = "terraform-aws-modules/eks/aws"
  version                                      = "19.21.0"
  vpc_id                                       = module.vpc.vpc_id
  control_plane_subnet_ids                     = module.vpc.public_subnets
  subnet_ids                                   = module.vpc.public_subnets
  cluster_version                              = "1.28"
  cluster_name                                 = "eks-cluster-terraform"
  cluster_endpoint_public_access               = true
  create_aws_auth_configmap                    = true
  create_cluster_security_group                = true
  node_security_group_enable_recommended_rules = true
  create_iam_role                              = true
  create_kms_key                               = true
  create_node_security_group                   = true
  cluster_security_group_name                  = "EKS_CLUSTER_SG"
  iam_role_name                                = "EKS_ROLE"
  node_security_group_name                     = "EKS-NODE-SG"
  node_security_group_tags                     = var.tags
  iam_role_tags                                = var.tags
  cluster_tags                                 = var.tags
  cluster_security_group_tags                  = var.tags
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    blue = {
      min_size     = 1
      max_size     = 4
      desired_size = 2

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"

    }
    green = {
      min_size     = 1
      max_size     = 4
      desired_size = 2

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }
  manage_aws_auth_configmap = true

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::956871201533:user/Terraform"
      username = "Terraform"
      groups   = ["system:masters"]
    },

  ]
  aws_auth_roles = [
    {
      rolearn  = module.eks.cluster_iam_role_arn
      username = "role1"
      groups   = ["system:masters"]
    }

  ]
}

output "cluster_iam_role_arn" {
  value = module.eks.cluster_iam_role_arn
}