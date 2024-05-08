locals {
  config_file = "../config/capp-master-config.csv"
  config_datatable = fileexists(local.config_file) ? csvdecode(file(local.config_file)) : null
  config = zipmap(local.config_datatable[*].name,local.config_datatable[*].value)


  s3_bucket_config    = local.config.s3_bucket_config
  s3_bucket_datatable = fileexists(local.s3_bucket_config) ? csvdecode(file(local.s3_bucket_config)) : null
  s3_bucket_filter    = [for row in local.s3_bucket_datatable : row if row.apply == "yes"]
  s3_bucket_map       = zipmap(local.s3_bucket_filter[*].id, local.s3_bucket_filter)

  s3_object_config    = local.config.s3_object_config
  s3_object_datatable = fileexists(local.s3_object_config) ? csvdecode(file(local.s3_object_config)) : null
  s3_object_filter    = [for row in local.s3_object_datatable : row if row.apply == "yes"]
  s3_object_map       = zipmap(local.s3_object_filter[*].id, local.s3_object_filter)
}

module "s3_bucket" {

    source = "../common/modules/s3"
    for_each = try(local.s3_bucket_map,{})
    bucket_name = try(each.value.bucket_name,null)
    force_destroy = try(each.value.force_destroy,false)
    versioning_enabled = try(each.value.versioning_enabled,false)
}

module "s3_object" {

    source = "../common/modules/s3-object"
    for_each = try(local.s3_object_map,{})
    bucket_name = try(each.value.bucket_name,null)
    bucket_key = try(each.value.bucket_key,null)
    object_source = try(each.value.object_source,null)

    depends_on = [ module.s3_bucket ]
  
}