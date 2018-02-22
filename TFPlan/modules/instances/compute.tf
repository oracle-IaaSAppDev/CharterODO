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

resource "null_resource" "omc-destroy" {
  count = "${var.compute_scale}"
  depends_on = ["baremetal_core_instance.TFInstance"]
  provisioner "remote-exec" {
    when = "destroy"
    inline = [
      "sudo /home/oracle/scripts/odo/kill.sh"
    ]
    connection {
      host = "${baremetal_core_instance.TFInstance.*.public_ip[count.index]}"
      type = "ssh"
      user = "opc"
      private_key = "${file(var.ssh_private_key)}"
    }
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

