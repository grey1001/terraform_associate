output "aws_iam_role_arn" {
  value = module.alb-ingress-controller.aws_iam_role_arn
}
output "cluster_iam_role_arn" {
  value = module.eks.cluster_iam_role_arn
}
output "vpc_id" {
  value = module.vpc.vpc_id
}
output "public_subnets" {
  value = module.vpc.public_subnets
}
output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}
output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}
output "cluster_name" {
  value = module.eks.cluster_name
}
output "oidc_provider" {
  value = module.eks.oidc_provider
}

