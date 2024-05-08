

resource "aws_instance" "myapp-ec2" {

  ami = var.required_ami
  instance_type = var.required_instance_type
  associate_public_ip_address = try(var.associate_public_ip_address, false)
  subnet_id = try(var.subnet_id,null)
  vpc_security_group_ids = try(var.vpc_security_group_ids,null)
  key_name = try(var.key_name,null)
  monitoring = try(var.monitoring,false)
  private_ip = try(var.private_ip, null)
  ebs_optimized = try(var.ebs_optimized,false)
  hibernation = try(var.hibernation,false)
  iam_instance_profile = try(var.iam_instance_profile,null)
  instance_initiated_shutdown_behavior =  try(var.instance_initiated_shutdown_behavior,"stop")
  user_data = try(file(var.user_data_source),null)
  tags = {
    Name = try(var.id,null)
  }
  
}