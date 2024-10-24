# variables.tf
variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"  # Changed to eu-central-1
}

# variables.tf
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  default     = "10.0.1.0/24"
}

variable "ami" {
  description = "AMI ID for the Jenkins EC2 instance"
}

variable "instance_type" {
  description = "Instance type for the Jenkins EC2 instance"
  default     = "t2.micro"
}

variable "key_pair" {
  description = "Key pair name for SSH access"
}

