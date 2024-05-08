output "db_endpoint"{
    value = try(aws_db_instance.db_instance.address, null)
}

output "db_port"{
    value = try(aws_db_instance.db_instance.port, null)
}


output "db_username"{
    value = try(aws_db_instance.db_instance.username, null)
}

output "db_password"{
    value = try(aws_db_instance.db_instance.password, null)
}