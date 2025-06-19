module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name                 = "${var.cluster_name}-vpc"
  cidr                 = var.vpc_cidr
  azs                  = var.public_subnet_azs
  public_subnets       = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  enable_nat_gateway   = false
  single_nat_gateway   = false
  enable_dns_support   = true
  enable_dns_hostnames = true
  map_public_ip_on_launch = true

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}