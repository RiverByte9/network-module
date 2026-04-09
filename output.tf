# Output the VPC name
output "vpc_name" {
  value = var.vpc_name
}

# Output the VPC ID
output "vpc_id" {
  value = aws_vpc.main.id
}