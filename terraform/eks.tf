module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 16.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  subnets = module.vpc.public_subnets
  vpc_id  = module.vpc.vpc_id

  # Launch template-based worker group
  worker_groups_launch_template = [
    {
      name                 = "default"
      instance_type        = "t3.medium"
      asg_desired_capacity = 1
      asg_min_size         = 1
      asg_max_size         = 2
    }
  ]

  # Optional - disable aws-auth management if you're doing it manually
  manage_aws_auth = false

  # Leave empty if not mapping roles/users yet
  map_roles    = []
  map_users    = []
  map_accounts = []

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

# Data sources to fetch cluster info
data "aws_eks_cluster" "cluster" {
  name       = module.eks.cluster_id
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name       = module.eks.cluster_id
  depends_on = [module.eks]
}

# Kubernetes provider config using IAM token from aws_eks_cluster_auth
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}
