resource "aws_security_group" "database_sg" {
  name        = "database-security-group"
  description = "Security group for MySQL RDS instance"
  vpc_id      = aws_vpc.main.id

  # Ingress rule: Allow MySQL traffic from the application security group
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.application_sg.id] # Allow traffic only from the application SG
  }

  # No direct access from the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow outbound access to internet if needed
  }

  tags = {
    Name = "Database-Security-Group"
  }
}
