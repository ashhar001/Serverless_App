# Variable for specifying the AWS region where resources will be deployed
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}
# Variable for specifying the name for the VPC
variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
  default     = "SimpletTimeService-eks-VPC" # Default VPC name set to SimpletTimeService-eks-VPC
}

# Variable for specifying the key pair name for EC2 instances in the EKS node group
variable "key_pair" {
  description = "The key pair name for EC2 instances in the EKS node group"
  type        = string
  default     = "eks-cluster-key" # Default key pair name set to eks-cluster-key
}

# Variable for specifying the container image for the Node.js application
variable "app_image" {
  description = "Container image for the Node.js application"
  type        = string
  default     = "ashhar001/simple-time-service:v1.0.0" # Default app image set to ashhar001/simple-time-service:v1.0.0
}

# Variable for specifying the deployment environment (e.g., dev, staging, prod)
variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev" # Default environment set to dev
}