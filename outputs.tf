# Output the first public subnet ID
output "public_subnet_ids" {
  value = data.aws_subnets.public_subnets.ids[0]
}

output "vpc_id" {
  value = data.aws_subnet.first_public_subnet.vpc_id
}