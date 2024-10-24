region         = "eu-central-1"
cluster_name   = "oesys-cluster"
vpc_name       = "oesys-cluster-VPC"
vpc_cidr       = "10.1.0.0/16"   # Updated CIDR range

azs            = ["eu-central-1a", "eu-central-1b"]

public_subnets = ["10.1.1.0/24", "10.1.2.0/24"]  
private_subnets = ["10.1.3.0/24", "10.1.4.0/24"] 

min_size       = 1
max_size       = 1
desired_size   = 1
instance_types = ["t3.large"]
capacity_type  = "SPOT"
