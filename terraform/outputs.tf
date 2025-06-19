output "cluster_name" {
  value = module.eks.cluster_id
}

output "eks_endpoint" {
  value = module.eks.cluster_endpoint
}

output "certificate_authority" {
  value = module.eks.cluster_certificate_authority_data
}
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}
