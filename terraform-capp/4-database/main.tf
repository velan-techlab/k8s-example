data "terraform_remote_state" "security" {
    backend = "local"
    config = {
        path = "../1-security/terraform.tfstate"
    }
}

data "terraform_remote_state" "networking" {
    backend = "local"
    config = {
        path = "../2-networking/terraform.tfstate"
    }
}

locals {
  config_file = "../config/capp-master-config.csv"
  config_datatable = fileexists(local.config_file) ? csvdecode(file(local.config_file)) : null
  config = zipmap(local.config_datatable[*].name,local.config_datatable[*].value)

  rds_config = local.config.rds_config
  rds_datatable = fileexists(local.rds_config) ? csvdecode(file(local.rds_config)) : null
  rds_filter = [for row in local.rds_datatable : row if row.apply == "yes"]
  rds_config_map       = zipmap(local.rds_filter[*].id, local.rds_filter)

  subnet_ids             = data.terraform_remote_state.networking.outputs.subnet_ids
  security_group_ids     = data.terraform_remote_state.networking.outputs.security_group_ids

}
module "db_instance" {

  source = "../common/modules/rds"
  for_each = try(local.rds_config_map,{})
  allocated_storage = try(each.value.allocated_storage,null)
  db_name = try(each.value.db_name,null)
  db_engine = try(each.value.db_engine,null)
  engine_version = try(each.value.engine_version,null)
  instance_class= try(each.value.instance_class,null)
  username = try(each.value.username,null)
  password = try(each.value.password,null)
  parameter_group_name = try(each.value.parameter_group_name,null)
  skip_final_snapshot = try(tobool(lower(each.value.skip_final_snapshot)),null)
  subnet_ids = try(each.value.db_subnet_group_names, null) == "" ? null : flatten([for id in split(";", each.value.db_subnet_group_names) : [try(local.subnet_ids[id])]])
  security_group_ids = try(each.value.security_group_names,null) == "" ? null : flatten([for id in split(";", each.value.security_group_names) : [try(local.security_group_ids[id])]])
  identifier = try(each.value.identifier,null)

  
}