#BMC Provider Configuration
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {
  description = "Region to create your instance, valid values are us-phoenix-1, or us-ashburn-1"
  default = "us-phoenix-1"
}

#Charter Specific Variables
variable "campaign_name" {
  default = "test"
}
variable "Subnet1OCID" {}
variable "Subnet2OCID" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}
variable "backup_id" {}
variable "SubnetOCID" {}
variable "image_id" {}
variable "private_key_password" {}
variable "compute_scale" {}
variable "InstanceShape" {}

variable "compartment_name" {
  default = "Charter"
}

variable "ad" {
  description = "Value of 1,2 or 3 expected to represent the AD your start your server instance in"
  default = 1
}

variable "image_name" {
  description = "BMC server image common name, find valid values in the BMC console drop down"
  default = "Oracle-Linux-7.3-2017.05.23-0"
}
