locals {
  config_file = "../config/capp-master-config.csv"
  config_datatable = fileexists(local.config_file) ? csvdecode(file(local.config_file)) : null
  config_map = zipmap(local.config_datatable[*].name,local.config_datatable[*].value)

  iam_policy_data = fileexists(local.config_map.iam_policy_config) ? csvdecode(file(local.config_map.iam_policy_config)) : []
  iam_policy      = [for row in local.iam_policy_data : row if row.apply == "yes"]
  iam_policy_map  = zipmap(local.iam_policy[*].id, local.iam_policy)

  iam_role_data = fileexists(local.config_map.iam_role_config) ? csvdecode(file(local.config_map.iam_role_config)) : []
  iam_role      = [for row in local.iam_role_data : row if row.apply == "yes"]
  iam_role_map  = zipmap(local.iam_role[*].id, local.iam_role)

}

resource "aws_iam_policy"  "iam_policy" {
  for_each = try(local.iam_policy_map,{})
  name = each.value.name
  description = each.value.description
  policy = try(each.value.policy,"") == "" ? null : file(each.value.policy)
}

module "iam_role" {
  source = "../common/modules/iam_role"
  for_each = try(local.iam_role_map,{})
  iam_role_name = try(each.value.iam_role_name,null)
  iam_assume_role = try(each.value.iam_assume_role,"") == "" ? null : file(each.value.iam_assume_role)
  iam_role_instance_profile_creation_enabled = try(each.value.iam_role_instance_profile_creation_enabled,"") == "" ? null : tobool(lower(each.value.iam_role_instance_profile_creation_enabled))
  iam_instance_profile_name = each.value.iam_instance_profile_name
  managed_policy_arns = try(each.value.policy_ids,"") == "" ? null : [for id in split(";",each.value.policy_ids) : aws_iam_policy.iam_policy[id].arn]
}