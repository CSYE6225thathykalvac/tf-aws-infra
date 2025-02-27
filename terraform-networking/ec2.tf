resource "aws_instance" "app_instance" {
  ami                    = var.custom_ami_id
  instance_type          = "t2.micro"              # Default instance type
  subnet_id              = aws_subnet.public[0].id # Launch in the first public subnet
  vpc_security_group_ids = [aws_security_group.application_sg.id]


  # Root block device configuration
  root_block_device {
    volume_size           = 25
    volume_type           = "gp2"
    delete_on_termination = true
  }

  # Disable termination protection
  disable_api_termination = false

  tags = {
    Name = "Application-Instance"
  }
  depends_on = [
    aws_vpc.main,
    aws_subnet.public,
    aws_security_group.application_sg
  ]
}