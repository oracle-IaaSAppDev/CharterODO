variable "campaign_name" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}
variable "backup_id" {}
variable "SubnetOCID" {}
variable "image_id" {}
variable "private_key_password" {}
variable "ad" {
  description = "Instance AD"
}
variable "loadbalancer_id" {
  description = "ID of the Loadbalancer"
}

variable "loadbalancer_backendset_id" {
  description = "Backend set ID for the Loadbalancer"
}

variable "compute_scale" {
  description = "Number of Compute nodes to scale out/in to"
}

variable "InstanceShape" {
  default = "VM.Standard1.2"
}

variable "2TB" {
  default = "2097152"
}

variable "256GB" {
  default = "262144"
}

variable "BootStrapFile" {
  default = "./userdata/bootstrap"
}
