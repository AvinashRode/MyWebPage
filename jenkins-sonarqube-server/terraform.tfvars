# terraform.tfvars
aws_region = "eu-central-1"  # Changed to eu-central-1
vpc_cidr = "10.0.0.0/16"
subnet_cidr = "10.0.1.0/24"
instance_type = "t2.large"
key_pair = "jenkins-server"  # Replace with your actual key pair name
ami = "ami-0592c673f0b1e7665"   # Update this to your preferred AMI ID
