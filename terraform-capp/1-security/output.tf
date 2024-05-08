output "iam_role_arns" {
    value = {for key,value in module.iam_role :  key => value.iam_role_arn }
}


output "iam_role_names" {
    value = {for key,value in module.iam_role :  key => value.instance_profile_arn }
}


output "iam_instance_profile_arns" {
    value = {for key,value in module.iam_role :  value.instance_profile_name => value.instance_profile_arn }
}

output "iam_instance_profile_names" {
    value = {for key,value in module.iam_role :  key => value.instance_profile_name }
}

