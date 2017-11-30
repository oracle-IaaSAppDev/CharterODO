data "template_file" "node" {
  template = "${file("/home/terraform/templates/chef/node.json.tpl")}"
  vars {
    ip_address = "${baremetal_core_instance.TFInstance.*.private_ip[count.index]}",
    campaign = "${var.campaign_name}" 
  }
}
resource "null_resource" "mount-exec" {
  count = "${var.compute_scale}"
  depends_on = ["baremetal_core_instance.TFInstance","baremetal_core_volume_attachment.TFBlock0Attach"]
  provisioner "remote-exec" {
    inline = [
      "sudo mount /dev/sdb1 /data1",
    ]
    connection {
      agent = false
      host = "${baremetal_core_instance.TFInstance.*.public_ip[count.index]}"
      type = "ssh"
      user = "opc"
      private_key = "${file(var.ssh_private_key)}"
    }
  }
}
resource "null_resource" "chef-config" {
  depends_on = ["null_resource.mount-exec"]
  count = "${var.compute_scale}"
  provisioner "remote-exec" {
    inline = [
      "sudo curl -L https://www.opscode.com/chef/install.sh | sudo bash",
      "sudo mkdir /etc/chef",
      "sudo mkdir /etc/chef/cookbooks",
      "sudo chown -R opc:opc /etc/chef"]
  connection {
      agent = false
      host = "${baremetal_core_instance.TFInstance.*.public_ip[count.index]}"
      type = "ssh"
      user = "opc"
      private_key = "${file(var.ssh_private_key)}"
    }

}
  provisioner "file" {
    content = "${data.template_file.node.rendered}"
    destination = "/etc/chef/node.json"
    connection {
      host = "${baremetal_core_instance.TFInstance.*.public_ip[count.index]}"
      type = "ssh"
      user = "opc"
      private_key = "${file(var.ssh_private_key)}"
    }
  }
  provisioner "file" {
    source = "/home/terraform/templates/chef/solo.rb"
    destination = "/etc/chef/solo.rb"
    connection {
      host = "${baremetal_core_instance.TFInstance.*.public_ip[count.index]}"
      type = "ssh"
      user = "opc"
      private_key = "${file(var.ssh_private_key)}"
    }
  }
  provisioner "file" {
    source = "/home/terraform/templates/chef/cookbooks/odo"
    destination = "/etc/chef/cookbooks/ODO"
    connection {
      host = "${baremetal_core_instance.TFInstance.*.public_ip[count.index]}"
      type = "ssh"
      user = "opc"
      private_key = "${file(var.ssh_private_key)}"
    }
  }

  provisioner "file" {
    source = "/home/terraform/templates/chef/cookbooks/omc_cloudagent"
    destination = "/etc/chef/cookbooks/omc_cloudagent"
    connection {
      host = "${baremetal_core_instance.TFInstance.*.public_ip[count.index]}"
      type = "ssh"
      user = "opc"
      private_key = "${file(var.ssh_private_key)}"
    }
  }
}
resource "null_resource" "chef-exec" {
 depends_on = ["null_resource.chef-config"]
 count = "${var.compute_scale}"
 provisioner "remote-exec" {
    inline = [
      "sudo chef-solo"
    ]
    connection {
      host = "${baremetal_core_instance.TFInstance.*.public_ip[count.index]}"
      type = "ssh"
      user = "opc"
      private_key = "${file(var.ssh_private_key)}"
    }
  }
}
