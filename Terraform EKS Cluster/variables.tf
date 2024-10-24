# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# AWS region
variable "region" {
  description = "The AWS region where resources will be deployed."
  type        = string
}

# Name of the cluster
variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

# Name of the VPC
variable "vpc_name" {
  description = "The name of the VPC for the EKS cluster."
  type        = string
}

# CIDR block for the VPC
variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

# Availability Zones
variable "azs" {
  description = "List of availability zones to be used."
  type        = list(string)
}

# Public subnets
variable "public_subnets" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
}

# Private subnets
variable "private_subnets" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
}

# Minimum size for autoscaling group
variable "min_size" {
  description = "Minimum number of instances in the autoscaling group."
  type        = number
}

# Maximum size for autoscaling group
variable "max_size" {
  description = "Maximum number of instances in the autoscaling group."
  type        = number
}

# Desired size for autoscaling group
variable "desired_size" {
  description = "Desired number of instances in the autoscaling group."
  type        = number
}

# Instance types for the cluster
variable "instance_types" {
  description = "List of EC2 instance types for the cluster nodes."
  type        = list(string)
}

# Capacity type (SPOT or ON-DEMAND)
variable "capacity_type" {
  description = "The capacity type for EC2 instances (SPOT or ON-DEMAND)."
  type        = string
}
