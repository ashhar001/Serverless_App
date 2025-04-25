# VPC Configuration for SimpleTimeService
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  # Setting the name of the VPC based on the variable
  name = var.vpc_name
  # Defining the CIDR block for the VPC
  cidr = "10.0.0.0/16"

  # Specifying the Availability Zones for the VPC
  azs = ["${var.aws_region}a", "${var.aws_region}b"]
  # Defining public subnets for the VPC
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  # Defining private subnets for the VPC
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  # Enabling NAT Gateway for the VPC
  enable_nat_gateway = true
  # Configuring a single NAT Gateway for the VPC
  single_nat_gateway = true

  # Adding tags to the VPC for identification and EKS integration
  tags = {
    Terraform   = "true"
    Environment = var.environment
    Project     = "SimpleTimeService"
  }

}