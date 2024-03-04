module "vpc" {
  source                     = "terraform-aws-modules/vpc/aws"
  version                    = "5.4.0"
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
    "Name" = "eks-secondary-cluster-RT"
  })
  igw_tags = merge(var.tags, {
    "Name" = "EKS-SECONDARY-IGW"
  })
  vpc_tags = var.vpc_tags
}


#EKS Cluster Code




module "eks" {
  source                                       = "terraform-aws-modules/eks/aws"
  version                                      = "19.21.0"
  vpc_id                                       = module.vpc.vpc_id
  control_plane_subnet_ids                     = module.vpc.public_subnets
  subnet_ids                                   = module.vpc.public_subnets
  cluster_version                              = "1.28"
  cluster_name                                 = var.cluster_name
  enable_irsa                                  = true
  cluster_endpoint_public_access               = true
  create_cluster_security_group                = true
  node_security_group_enable_recommended_rules = true
  create_iam_role                              = true
  create_kms_key                               = true
  create_node_security_group                   = true
  iam_role_name                                = "EKS_ROLE"
  node_security_group_name                     = "EKS-NODE-SG"
  node_security_group_tags                     = var.tags
  iam_role_tags                                = var.tags
  cluster_tags                                 = var.tags
  cluster_security_group_tags                  = var.tags
  cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent              = true
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
    }

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


  eks_managed_node_groups = {

    blue = {
      min_size     = 1
      max_size     = 4
      desired_size = 2

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"



    }
    # green = {
    #   min_size     = 1
    #   max_size     = 4
    #   desired_size = 2

    #   instance_types = ["t3.micro"]
    #   capacity_type  = "ON_DEMAND"

    # }
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

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_name
  depends_on = [
    module.eks.eks_managed_node_groups,
  ]
}
data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
  depends_on = [
    module.eks.eks_managed_node_groups,
  ]
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "${module.eks.cluster_name}-ebs-csi"
  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}


module "alb-ingress-controller" {
  depends_on   = [module.eks]
  source       = "campaand/alb-ingress-controller/aws"
  version      = "2.0.0"
  controller_iam_role_name = "IRSA-EKSLoadBalancerControllerRole"
  cluster_name = module.eks.cluster_name
 
}

module "eks-external-dns" {
  source                           = "lablabs/eks-external-dns/aws"
  version                          = "1.2.0"
  cluster_identity_oidc_issuer     = module.eks.oidc_provider
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  irsa_role_name_prefix = "external-dns-irsa"
}




module "kube_prometheus_stack" {
  depends_on = [ module.eks ]
  source = "sparkfabrik/prometheus-stack/sparkfabrik"

  prometheus_stack_chart_version          = "31.0.0"
  prometheus_adapter_chart_version        = "3.0.1"
  namespace                               = "kube-prometheus-stack"
  regcred                                 = "regcred-secret"

}


# module "eks_monitoring_logging" {

#     source = "shamimice03/eks-monitoring-logging/aws"

#     cluster_name      = module.eks.cluster_name
#     aws_region        = var.aws_region
#     namespace         = "amazon-cloudwatch"

#     enable_cwagent    = true
#     enable_fluent_bit = true

#     # Attach CloudWatchServerPolicy to EKS nodegroup roles
#     nodegroup_roles = [
#       "blue-eks-node-group-20231228171821964400000001",
#       "green-eks-node-group-20231228171821964700000003",
#     ]
# }