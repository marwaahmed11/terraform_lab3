output "my-vpc-id" {
  value = aws_vpc.iti-vpc.id
}

output "security-group-id" {
  value = aws_security_group.allow_tls.id
}

output "public-subnet-1" {
  value =  aws_subnet.subnets-public[0].id

}
output "public-subnet-2" {
  value = aws_subnet.subnets-public[1].id

}

output "private-subnet-1" {
  value = aws_subnet.subnets-private[0].id

}
output "private-subnet-2" {
  value = aws_subnet.subnets-private[1].id

}