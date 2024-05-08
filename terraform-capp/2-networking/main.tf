locals {
  config_file = "../config/capp-master-config.csv"
  config_datatable = fileexists(local.config_file) ? csvdecode(file(local.config_file)) : null
  config = zipmap(local.config_datatable[*].name,local.config_datatable[*].value)

  vpc_config_file = local.config.vpc_config
  vpc_datatable =  fileexists(local.vpc_config_file) ? csvdecode(file(local.vpc_config_file)) : null
  vpc_config_map = zipmap(local.vpc_datatable[*].name,local.vpc_datatable)
  
  
  

  subnet_config_file = local.config.subnet_config
  subnet_datatable = fileexists(local.subnet_config_file) ? csvdecode(file(local.subnet_config_file)) : null
  subnet_config_map = zipmap(local.subnet_datatable[*].name,local.subnet_datatable)

  routetable_config_file = local.config.routetable_config
  routetable_datatable = fileexists(local.routetable_config_file) ? csvdecode(file(local.routetable_config_file)) : null
  routetable_config_map = zipmap(local.routetable_datatable[*].name,local.routetable_datatable)

  routetableassociation_config_file = local.config.routetableassociation_config
  routetableassociation_datatable = fileexists(local.routetableassociation_config_file) ? csvdecode(file(local.routetableassociation_config_file)) : null
  routetableassociation_config_map = zipmap([for data in local.routetableassociation_datatable 
        : join(":",[data.routetablename,data.subnetname]) ],local.routetableassociation_datatable)

  routetablerule_config_file = local.config.routetablerule_config
  routetablerule_datatable  = fileexists(local.routetablerule_config_file) ? csvdecode(file(local.routetablerule_config_file)) : null
  routetablerule_config_map = zipmap(local.routetablerule_datatable[*].routetablename,local.routetablerule_datatable)

  network_acl_config_file = local.config.network_acl_config
  network_acl_datatable = fileexists(local.network_acl_config_file) ? csvdecode(file(local.network_acl_config_file)) : null
  network_acl_filter = [for row in local.network_acl_datatable : row if row.apply == "yes"]
  network_acl_config_map = zipmap(local.network_acl_filter[*].naclname,local.network_acl_filter)

  network_acl_rule_cofig_file = local.config.network_acl_config_rule_config
  network_acl_rule_datatable = fileexists(local.network_acl_rule_cofig_file) ? csvdecode(file(local.network_acl_rule_cofig_file)) : null
  network_acl_rule_filter = [for row in local.network_acl_rule_datatable : row if row.apply == "yes"]
  network_acl_rule_config_map = zipmap(local.network_acl_rule_filter[*].id,local.network_acl_rule_filter)

  security_group_config_file = local.config.security_group_config
  security_group_datatable = fileexists(local.security_group_config_file) ? csvdecode(file(local.security_group_config_file)) : null 
  security_group_filter = [for row in local.security_group_datatable : row if row.apply == "yes"]
  security_group_config_map = zipmap(local.security_group_filter[*].securitygroupname,local.security_group_filter)

  security_group_rule_config_file = local.config.security_group_rule_config
  security_group_rule_datatable = fileexists(local.security_group_rule_config_file) ? csvdecode(file(local.security_group_rule_config_file)) : null 
  security_group_rule_filter = [for row in local.security_group_rule_datatable : row if row.apply == "yes"]
  security_group_rule_config_map = zipmap(local.security_group_rule_filter[*].security_group_rule_name,local.security_group_rule_filter)
  #zipmap(local.routetableassociation_datatable[*].routetablename,local.routetableassociation_datatable)

  vpc_endpoint_config    = local.config.vpc_endpont_config
  vpc_endpoint_datatable = fileexists(local.vpc_endpoint_config) ? csvdecode(file(local.vpc_endpoint_config)) : null
  vpc_endpoint_filter    = [for row in local.vpc_endpoint_datatable : row if row.apply == "yes"]
  vpc_endpoint_map       = zipmap(local.vpc_endpoint_filter[*].id, local.vpc_endpoint_filter)
}




resource "aws_vpc" "capp-vpc" {

  for_each = try(local.vpc_config_map,{})
  cidr_block = each.value.cidr
  instance_tenancy = each.value.instance_tenancy
  enable_dns_hostnames = each.value.dns_hostnames
  enable_dns_support = each.value.dns_support
  tags = {
    Name = each.key
  }
}



resource "aws_subnet" "capp-subnet" {

    for_each = try(local.subnet_config_map,{})
    vpc_id = aws_vpc.capp-vpc[each.value.vpcname].id
    cidr_block = each.value.cidr
    availability_zone = each.value.availabilityzone
    tags = {
      Name = each.key
    }
    
}

resource "aws_route_table" "capp-routetable" {
    for_each =  try(local.routetable_config_map,{})
    vpc_id = aws_vpc.capp-vpc[each.value.vpcname].id
    tags = {
      Name = each.key
    }
}

resource "aws_route_table_association" "capp-routetable-association" {
   
   for_each = try(local.routetableassociation_config_map,{})
   route_table_id = aws_route_table.capp-routetable[each.value.routetablename].id
   
   subnet_id = aws_subnet.capp-subnet[each.value.subnetname].id
}

# resource "aws_route" "capp-routetable-rule" {

#     for_each = try(local.routetablerule_config_map,[])
#     route_table_id =  aws_route_table.capp-routetable[each.value.routetablename].id
#     destination_cidr_block = each.value.destination_cidr_block
    
  
# }

resource "aws_network_acl" "capp-nacl" {
  
   for_each = try(local.network_acl_config_map,{})
   vpc_id = aws_vpc.capp-vpc[each.value.vpcname].id
   subnet_ids = try(each.value.subnetnames,null) == "" ? null : flatten([for subnetname in split(";",each.value.subnetnames) : [aws_subnet.capp-subnet[subnetname].id]])  

   tags = {
     Name = each.value.naclname
   }
   
}

resource "aws_network_acl_rule" "capp-nacl-rule" {

    for_each = try(local.network_acl_rule_config_map,{})
    network_acl_id = aws_network_acl.capp-nacl[each.value.naclname].id
    rule_number = each.value.rule_number
    protocol = each.value.protocol
    rule_action = each.value.rule_action
    egress = try(each.value.egress,"") == "" ? null : tobool(lower(each.value.egress))
    cidr_block = each.value.cidr_block
    from_port = each.value.from_port
    to_port = each.value.to_port

}

resource "aws_security_group" "capp-security-group" {

    for_each = try(local.security_group_config_map,{})
    name = each.value.securitygroupname
    description = each.value.description
    revoke_rules_on_delete = tobool(lower(each.value.revokerulesondelete))
    vpc_id = aws_vpc.capp-vpc[each.value.vpcname].id
    tags = try(jsondecode(each.value.tags),null)

   
}

resource "aws_security_group_rule" "capp-security-group-rule" {

    for_each = try(local.security_group_rule_config_map,{})
    security_group_id = aws_security_group.capp-security-group[each.value.security_group_name].id
    type =  each.value.type
    to_port = each.value.to_port
    from_port = each.value.from_port
    protocol = each.value.protocol
    cidr_blocks = try(each.value.cidr_blocks,null) == "" ? null : split(";",each.value.cidr_blocks)
    prefix_list_ids = try(each.value.prefix_lists_ids,null) == "" ?  null : split(";",each.value.prefix_lists_ids)
    source_security_group_id = try(each.value.source_security_group_name,null)== "" ? null : aws_security_group.capp-security-group[each.value.source_security_group_name].id
    self = try(each.value.target_self_enabled,null)== "" ? null : tobool(lower(each.value.target_self_enabled))
    description = each.value.description
}


module "endpoints" {
  source = "../common/modules/vpc_endpoints"

  for_each             = try(local.vpc_endpoint_map, {})
  vpc_id               = aws_vpc.capp-vpc[each.value.vpcname].id
  endpoint_creation            = tobool(lower(each.value.endpoint_creation))
  service_name                 = each.value.service_name
  endpoint_type                = each.value.endpoint_type
  auto_accept_connection       = try(each.value.auto_accept_connection, "") == "" ? null : tobool(lower(each.value.auto_accept_connection))
  private_dns_enabled          = try(each.value.private_dns_enabled) == "" ? null : tobool(lower(each.value.private_dns_enabled))
  subnet_ids                   = try(each.value.subnet_ids, null) == "" ? null : flatten([for id in split(";", each.value.subnet_ids) : [try(aws_subnet.capp-subnet[id].id)]])
  gateway_only_route_table_ids = try(each.value.route_table_ids, null) == "" ? null : flatten([for id in split(";", each.value.route_table_ids) : [try(aws_route_table.capp-routetable[id].id)]])
  security_group_ids           = try(each.value.security_group_ids, null) == "" ? null : flatten([for sg_id in split(";", each.value.security_group_ids) : [try(aws_security_group.capp-security-group[sg_id].id)]])
}
