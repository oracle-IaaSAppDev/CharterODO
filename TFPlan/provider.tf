provider "baremetal" {
  tenancy_ocid         = "${var.tenancy_ocid}"
  user_ocid            = "${var.user_ocid}"
  fingerprint          = "${var.fingerprint}"
  private_key_path     = "${var.private_key_path}"
  region               = "${var.region}"
  private_key_password = "${var.private_key_password}"
}

module "bmc_resources" {
  source = "/home/terraform/templates/campaign/modules/datasources"
  tenancy_ocid = "${var.tenancy_ocid}"
}