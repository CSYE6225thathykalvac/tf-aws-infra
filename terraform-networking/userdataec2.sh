#!/bin/bash
echo "Hello World!"

sudo echo "DB_NAME=${DB_NAME}" | sudo tee -a /opt/csye6225/.env
sudo echo "DB_HOST=${DB_HOST}" | sudo tee -a /opt/csye6225/.env
sudo echo "DB_PASSWORD=${DB_PASSWORD}" | sudo tee -a /opt/csye6225/.env
sudo echo "DB_USER=${DB_USER}" | sudo tee -a /opt/csye6225/.env
sudo echo "DB_PORT=3306" | sudo tee -a /opt/csye6225/.env
sudo echo "PORT=${PORT}" | sudo tee -a /opt/csye6225/.env
sudo echo "S3_BUCKET_NAME=${S3_BUCKET_NAME}" | sudo tee -a /opt/csye6225/.env
sudo echo "AWS_REGION=${AWS_REGION}" | sudo tee -a /opt/csye6225/.env

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/cloud-watch.json -s
sudo systemctl restart webapp.service
