variable "iam_role_name" {
  type = string
  default = null
}

variable "iam_assume_role" {
    type = string
  default = null
}

variable "description" {
    type = string
  default = null
}

variable "managed_policy_arns" {
  type = list(string)
  default = null
}

variable "iam_role_instance_profile_creation_enabled" {
    type = bool
  default = false
}

variable "iam_instance_profile_name" {
    type = string
  default = null
}


