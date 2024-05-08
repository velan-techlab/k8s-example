variable "global_resource_tags" {
    type = map(string)
    default = null 
}

variable "required_ami" {
    type = string
    default = null
}

variable "required_instance_type" {
    type = string
    default = null
  
}

variable "associate_public_ip_address" {
    type = bool
    default = false
}

variable "subnet_id" {
    type = string
    default = null 
}

variable "key_name" {
  type = string
  default = null
}

variable "monitoring" {
  type = bool
  default = false
}

variable "private_ip" {
  type = string
  default = null
}

variable "ebs_optimized" {
    type = bool
    default = false 
}


variable "hibernation" {
  type = bool
  default = false
}

variable "iam_instance_profile" {
    type = string
    default = null
}

variable "instance_initiated_shutdown_behavior" {
    type = string
    default = null 
}

variable "build_user_data_enabled" {
    type = bool
    default = false
}

variable "user_data_source" {
    type = string
    default = null
}

variable "vpc_security_group_ids" {
    type = list(string)
    default = null
}

variable "id" {
    type = string
    default = null
  
}
