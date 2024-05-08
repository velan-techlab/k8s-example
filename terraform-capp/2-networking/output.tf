output "subnet_ids" {
  value = { for key, value in aws_subnet.capp-subnet : key => value.id }
}

output "security_group_ids" {

  value = {for key, value in aws_security_group.capp-security-group : key => value.id}
  
}