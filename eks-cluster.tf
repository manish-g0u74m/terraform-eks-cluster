module "eks" {
  # Cluster module template
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 20.0"
  
  # Cluster info.
  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true
  
  enable_cluster_creator_admin_permissions = true
  
  # Cluster addons. 
  cluster_addons = {
    "vpc-cni" = {
      most_recent = true
      resolve_conflicts   = "OVERWRITE"
    }
    "coredns" = {
      most_recent = true
      resolve_conflicts = "OVERWRITE"
    }
    "kube-proxy" = {
      most_recent = true
      resolve_conflicts = "OVERWRITE"
    }
  }

  # Node group configuration
  eks_managed_node_groups = {
    manish-cluster-ng = {
      ami_type      = var.eks_node_ami_type
      key_name      = var.key_pair_name
      instance_types = var.eks_node_instance_types
      min_size       = var.eks_node_min_size
      max_size       = var.eks_node_max_size
      desired_size   = var.eks_node_desired_size
      disk_size      = var.eks_node_disk_size

      tags = {
        Name        = "${var.eks_cluster_name}-node-group"
      }
    }
  }

  tags = {
    Name        = var.eks_cluster_name
    Environment = var.environment
    Terraform   = "true"
  } 
}