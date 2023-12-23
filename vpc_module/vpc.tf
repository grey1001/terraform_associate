resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags       = var.vpc_tags
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.my_vpc
  availability_zone       = element(var.azs, count.index)
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  tags                    = var.subnet_tags
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.my_vpc
  availability_zone = element(var.azs, count.index)
  cidr_block        = var.private_subnet_cidrs[count.index]
  tags              = var.subnet_tags
}

resource "aws_internet_gateway" "vpc_gw" {
  vpc_id = aws_vpc.my_vpc.id
  tags   = var.igw_tags
}

resource "aws_route_table" "vpc_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0"
    gateway_id = aws_internet_gateway.vpc_gw.id
  }
  tags = var.vpc_rt_tags
}
resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.vpc_rt.id
}