output "db_details" {
    sensitive = true
    value = {for key,value in module.db_instance :  key => { "endpoint" : value.db_endpoint
    "port" : value.db_port
    "username" : value.db_username
    "password" : value.db_password } }
}
 