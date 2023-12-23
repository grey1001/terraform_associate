# resource "github_repository" "test-repo" {
#     name = "mytestrepo"
#     visibility = "public"
  
# }

# resource "aws_eip" "lb" {
#     domain = "vpc"
# }

# output "public_ip" {
#   value = aws_eip.lb
# }

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

# resource "aws_instance" "web" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t3.micro"
#   count = 3

#   tags = {
#     Name = "myinstance.${count.index}"
#   }
# }

# output "arn" {
#   value = aws_instance.web[*].arn  
# } 


import {
  to = aws_instance.test
  id = "i-0a78923a9dd5b6f56"
}