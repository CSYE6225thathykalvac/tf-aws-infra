resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidrn

  tags = {
    Name = "Main-VPC"
  }
}

