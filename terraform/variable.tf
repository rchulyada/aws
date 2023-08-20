variable "aws_sso_profile" {
  type = string
  description = "comment about variable"
  sensitive = true
}

variable "bucket_name" {
  type = string
  description = "name of bucket to be created"
}

variable "tag_environment" {
  type = string
  description = "Tag environment"
}

variable "tag_name" {
  type = string
  description = "Tag environment name"
}

variable "folder_path" {
  type = string
  description = "dist folder path on angular build"
}

variable "geo_restriction_locations" {
  type = list(string)
  description = "restriction using country codes"
}