variable "bucket_name" {
  type = string
  default = null
}


variable "force_destroy" {
  type = bool
  default = false   
}


variable "versioning_enabled" {
   type = bool
   default = false
}
