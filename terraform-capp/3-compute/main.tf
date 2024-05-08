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

  ec2_config_file = local.config.ec2_config
  ec2_config_datatable = fileexists(local.ec2_config_file) ? csvdecode(file(local.ec2_config_file)) : null
  ec2_config_map = zipmap(local.ec2_config_datatable[*].id,local.ec2_config_datatable)

  subnet_ids             = data.terraform_remote_state.networking.outputs.subnet_ids
  security_group_ids     = data.terraform_remote_state.networking.outputs.security_group_ids
  

}

module "ec2"  {
    source = "../common/modules/ec2"

    for_each = try(local.ec2_config_map,{})
    required_ami = each.value.required_ami
    required_instance_type = each.value.required_instance_type
    subnet_id = local.subnet_ids[each.value.subnet_id]
    vpc_security_group_ids = [local.security_group_ids[each.value.vpc_security_group_ids]]
    associate_public_ip_address = try(tobool(lower(each.value.associate_public_ip_address)),false)
    user_data_source = each.value.user_data_source
    iam_instance_profile = each.value.iam_instance_profile
   # key_name = each.value.key_name
   # id = each.value.id
  
}

