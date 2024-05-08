
variable "allocated_storage" {
  type = string
  default = null  
}

variable "db_name" {
  type = string
  default = null
}

variable "db_engine" {
  type = string
  default = null
}

variable "engine_version" {
  type = string
  default = null
}

variable "instance_class" {
  type = string
  default = null
}

variable "username" {
    type = string
  default = null
}

variable "password" {
    type = string
  default = null
}

variable "parameter_group_name" {
    type = string
  default = null
}

variable "skip_final_snapshot" {

  type = bool
  default = false
  
}

variable "subnet_ids" {
   type = list(string)
   default = null
}

variable "identifier" {
  type = string
  default  = null  
}

variable "security_group_ids" {
  type = list(string)
   default = null
  
}