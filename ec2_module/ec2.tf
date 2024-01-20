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

module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.0"
  ami     = "ami-01d21b7be69801c2f"
  count   = 3

  name = "Prod_instance-${count.index}"

  instance_type          = "t2.micro"
  key_name               = "demo"
  monitoring             = true
  vpc_security_group_ids = [module.security-group.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

}
