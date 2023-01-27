output "public-ec2-1" {
  value = aws_instance.ec2_public[0].id
}
output "public-ec2-2" {
  value = aws_instance.ec2_public[1].id
}

output "private-ec2-1" {
  value = aws_instance.ec2_private[0].id
}
output "private-ec2-2" {
  value = aws_instance.ec2_private[1].id
}