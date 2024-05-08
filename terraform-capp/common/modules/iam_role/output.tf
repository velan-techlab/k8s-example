output "iam_role_arn"{
    value = try(aws_iam_role.iam_role.arn, null)
}

output "iam_role_name"{
    value = try(aws_iam_role.iam_role.name, null)
}

output "iam_role_id"{
    value = try(aws_iam_role.iam_role.id, null)
}

output "instance_profile_name"{
    value = try(aws_iam_instance_profile.iam_instance_profile[0].name, null)
}

output "instance_profile_arn"{
    value = try(aws_iam_instance_profile.iam_instance_profile[0].arn, null)
}