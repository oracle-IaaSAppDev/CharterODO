module "load_balancer" {
  source = "/home/terraform/templates/campaign/modules/LB"
  campaign_name = "${var.campaign_name}"
  compartment_ocid = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  Subnet1OCID = "${var.Subnet1OCID}"
  Subnet2OCID = "${var.Subnet2OCID}"
}

module "instances" {
  source = "/home/terraform/templates/campaign/modules/instances"
  campaign_name = "${var.campaign_name}"
  compartment_ocid = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  ad = "${lookup(module.bmc_resources.ads[var.ad - 1],"name")}"
  SubnetOCID = "${var.SubnetOCID}" 
  image_id = "${var.image_id}" 
  compute_scale = "${var.compute_scale}"
  backup_id = "${var.backup_id}" 
  loadbalancer_backendset_id = "${module.load_balancer.lb_bes_id[0]}"
  InstanceShape = "${var.InstanceShape}"
  loadbalancer_id = "${module.load_balancer.lb_id[0]}"
  ssh_private_key = "${var.ssh_private_key}" 
  ssh_public_key = "${var.ssh_public_key}"
  private_key_password = "${var.private_key_password}" 
}
