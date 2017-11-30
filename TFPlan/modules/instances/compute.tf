resource "baremetal_core_instance" "TFInstance" {
  count = "${var.compute_scale}"
  availability_domain = "${var.ad}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "${var.campaign_name}-${count.index}"
  hostname_label = "${var.campaign_name}-${count.index}"
  shape = "${var.InstanceShape}"
  image = "${var.image_id}"
  subnet_id = "${var.SubnetOCID}"
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }

}

resource "baremetal_load_balancer_backend" "lb-be" {
    count = "${var.compute_scale}"
    depends_on = ["null_resource.chef-exec"]
    load_balancer_id = "${var.loadbalancer_id}"
    backendset_name  = "${var.loadbalancer_backendset_id}"
    ip_address       = "${baremetal_core_instance.TFInstance.*.private_ip[count.index]}"
    port             = 8101
    backup           = false
    drain            = false
    offline          = false
    weight           = 1

  }

