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

  user_data = <<-EOT
    #!/bin/bash
      echo "DB_HOST=${aws_db_instance.mysql_db.address}" | sudo tee /opt/csye6225/.env 
      echo "DB_PORT=3306" | sudo tee -a /opt/csye6225/.env 
      echo "DB_USER=${var.db_username}" | sudo tee -a /opt/csye6225/.env 
      echo "DB_PASSWORD=${var.db_password}" | sudo tee -a /opt/csye6225/.env
      echo "DB_NAME=${var.db_name}" | sudo tee -a /opt/csye6225/.env 
      echo "PORT=${var.application_port}" | sudo tee -a /opt/csye6225/.env 
      echo "S3_BUCKET_NAME=${aws_s3_bucket.attachments.id}" | sudo tee -a /opt/csye6225/.env 
      echo "AWS_REGION=${var.aws_region}" | sudo tee -a /opt/csye6225/.env 

    EOT

  tags = {
    Name = "Application-Instance"
  }
  depends_on = [
    aws_vpc.main,
    aws_subnet.public,
    aws_security_group.application_sg
  ]
}