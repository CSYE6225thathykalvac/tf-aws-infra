resource "aws_db_subnet_group" "rds_private_subnet_group" {
  name        = "rds-private-subnet-group"
  description = "Subnet group for private RDS instances"
  subnet_ids  = aws_subnet.private[*].id # Private subnets only

  tags = {
    Name = "Private-RDS-Subnet-Group"
  }
}
