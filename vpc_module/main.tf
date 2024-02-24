
resource "aws_vpc" "main" {
  cidr_block = var.cidr
  enable_dns_hostnames = true
  tags       = var.tags
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  availability_zone = var.subnet_cidr_az_map[element(var.public_subnet_cidrs, count.index)]
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  tags = merge(var.tags, {
    "ResourceType" = "PublicSubnet"
    "Name"         = "prod_public_subnet_${count.index + 1}_${var.subnet_cidr_az_map[element(var.public_subnet_cidrs, count.index)]}"
  })
}


resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  availability_zone = var.subnet_cidr_az_map[element(var.private_subnet_cidrs, count.index)]
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  tags = merge(var.tags, {
    "ResourceType" = "PrivateSubnet"
    "Name"         = "prod_private_subnet${count.index + 1}_${var.subnet_cidr_az_map[element(var.private_subnet_cidrs, count.index)]}"
  })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, {
    "Name" = "Prod_IGW"
    }
  )
}
resource "aws_route_table" "second_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = merge(var.tags, {
    "Name" = "Prod_RT"
    }
  )
}

resource "aws_route_table_association" "second_rt_asso" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.second_rt.id
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.sg_ports
    
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    "Name" = "Prod_SG"
  })
}


resource "aws_s3_bucket" "prod-s3" {
  bucket = "abiwon-prod-s3"

  tags = var.tags
}



resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.prod-s3.id
  versioning_configuration {
    status = "Enabled"
  }
  depends_on = [ aws_s3_bucket.prod-s3 ]
}