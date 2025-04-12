resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-launch-template-"
  image_id      = var.custom_ami_id
  instance_type = "t2.micro"
  key_name      = var.key_pair_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.application_sg.id]
  }



  #   user_data = base64encode(<<-EOT
  #     #!/bin/bash
  #     echo "DB_HOST=${aws_db_instance.mysql_db.address}" | sudo tee /opt/csye6225/.env 
  #     echo "DB_PORT=3306" | sudo tee -a /opt/csye6225/.env 
  #     echo "DB_USER=${var.db_username}" | sudo tee -a /opt/csye6225/.env 
  #     echo "DB_PASSWORD=${var.db_password}" | sudo tee -a /opt/csye6225/.env
  #     echo "DB_NAME=${var.db_name}" | sudo tee -a /opt/csye6225/.env 
  #     echo "PORT=${var.application_port}" | sudo tee -a /opt/csye6225/.env 
  #     echo "S3_BUCKET_NAME=${aws_s3_bucket.attachments.id}" | sudo tee -a /opt/csye6225/.env 
  #     echo "AWS_REGION=${var.aws_region}" | sudo tee -a /opt/csye6225/.env 

  #     sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/cloud-watch.json -s
  #     sudo systemctl restart webapp.service
  #   EOT
  #   )
  user_data = base64encode(templatefile("${path.module}/userdataec2.sh", {
    DB_HOST        = aws_db_instance.mysql_db.address
    DB_NAME        = var.db_name
    DB_USER        = var.db_username
    DB_PASSWORD    = jsondecode(aws_secretsmanager_secret_version.db_password.secret_string)["DB_PASSWORD"]
    DB_PORT        = 3306
    S3_BUCKET_NAME = aws_s3_bucket.attachments.id
    AWS_REGION     = var.aws_region
    PORT           = var.application_port
  }))


  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "App-Instance"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}