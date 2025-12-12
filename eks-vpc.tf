data "aws_availability_zones" "available_zones" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 5.0.0"

  name = "${var.eks_cluster_name}-vpc"
  cidr = var.vpc_cidr_block

  # slice function fetches the first 3 availability zones in the available region
  # 
  # azs = var.azs
  azs = slice(data.aws_availability_zones.available_zones.names, 0, 3)

  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = true # Enable NAT Gateway for private subnets
  single_nat_gateway   = true # Use a single NAT Gateway for cost savings
  enable_dns_hostnames = true
    
  tags = {
    Name        = "${var.eks_cluster_name}-vpc"
    Environment = var.environment
    Terraform   = "true"
  }
}