resource "baremetal_core_volume" "volume0" {
  count = "${var.compute_scale}"
  availability_domain ="${var.ad}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "${var.campaign_name}-${count.index}"
  volume_backup_id = "${var.backup_id}"
  size_in_mbs = "102400"
}
resource "baremetal_core_volume_attachment" "TFBlock0Attach" {
  count = "${var.compute_scale}"
  depends_on = ["baremetal_core_volume.volume0"]
  attachment_type = "iscsi"
  compartment_id = "${var.compartment_ocid}"
  instance_id = "${baremetal_core_instance.TFInstance.*.id[count.index]}"
  volume_id = "${baremetal_core_volume.volume0.*.id[count.index]}"
  provisioner "remote-exec" {
    inline = [
      "sudo iscsiadm -m node -o new -T ${self.iqn} -p ${self.ipv4}:${self.port}",
      "sudo iscsiadm -m node -o update -T ${self.iqn} -n node.startup -v automatic",
      "sudo iscsiadm -m node -T ${self.iqn} -p ${self.ipv4}:${self.port} -l",
    ]
    connection {
      host = "${baremetal_core_instance.TFInstance.*.public_ip[count.index]}"
      type = "ssh"
      user = "opc"
      private_key = "${file(var.ssh_private_key)}"
    }
  }
}

