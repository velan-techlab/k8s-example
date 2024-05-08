resource "aws_db_instance" "db_instance" {

  allocated_storage    = var.allocated_storage
  db_name              = var.db_name
  engine               = var.db_engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot  = var.skip_final_snapshot
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  multi_az = false
  identifier = var.identifier
  vpc_security_group_ids = var.security_group_ids
#   allocated_storage    = 10
#   db_name              = "mydb"
#   engine               = "mysql"
#   engine_version       = "5.7"
#   instance_class       = "db.t3.micro"
#   username             = "foo"
#   password             = "foobarbaz"
#   parameter_group_name = "default.mysql5.7"
#   skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = var.subnet_ids
}