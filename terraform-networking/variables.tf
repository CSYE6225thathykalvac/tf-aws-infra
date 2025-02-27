variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_cidr" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "custom_ami_id" {
  type = string
}

variable "application_port" {
  type = number
}