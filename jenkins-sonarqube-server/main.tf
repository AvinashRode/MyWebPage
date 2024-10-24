# Define the VPC
resource "aws_vpc" "oesys" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Oesys-Jenkins-VPC"
  }
}

# Define the Subnet
resource "aws_subnet" "oesys" {
  vpc_id            = aws_vpc.oesys.id
  cidr_block        = var.subnet_cidr
  availability_zone = "eu-central-1a"

  tags = {
    Name = "Oesys-Jenkins-Subnet"
  }
}

# Define the Internet Gateway
resource "aws_internet_gateway" "oesys" {
  vpc_id = aws_vpc.oesys.id

  tags = {
    Name = "Oesys-Jenkins-IGW"
  }
}

# Define the Route Table
resource "aws_route_table" "oesys" {
  vpc_id = aws_vpc.oesys.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.oesys.id
  }

  tags = {
    Name = "Oesys-Jenkins-RT"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "oesys" {
  subnet_id      = aws_subnet.oesys.id
  route_table_id = aws_route_table.oesys.id
}

# Define the Security Group Module
module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "Oesys-Jenkins-sg"
  description = "Security group for Jenkins server"
  vpc_id      = aws_vpc.oesys.id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Jenkins port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 9000
      to_port     = 9000
      protocol    = "tcp"
      description = "SonarQube port"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "All traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

# Define the EC2 Instance Module
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                   = "Oesys-Jenkins-server"
  instance_type          = var.instance_type
  ami                    = var.ami
  key_name               = var.key_pair
  monitoring             = false
  vpc_security_group_ids = [module.sg.security_group_id]
  subnet_id              = aws_subnet.oesys.id
  user_data              = file("userdata.sh")

  root_block_device = [
    {
      volume_size = 25
      volume_type = "gp3"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "Oesys-Jenkins-server"
  }
}

# Define the Elastic IP and associate it with the EC2 instance
resource "aws_eip" "eip" {
  instance = module.ec2_instance.id
  domain   = "vpc"
}
