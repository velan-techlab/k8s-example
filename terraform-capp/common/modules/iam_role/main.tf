resource "aws_iam_role" "iam_role" {

   name = var.iam_role_name
   assume_role_policy  =  try(var.iam_assume_role,"Terraform")
   description = var.description
   managed_policy_arns = try(var.managed_policy_arns,null)
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
    
    count = try(var.iam_role_instance_profile_creation_enabled,false) == true ? 1 : 0
    name = try(var.iam_instance_profile_name,null)
    role = aws_iam_role.iam_role.name 
  
}

