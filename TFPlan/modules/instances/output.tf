# Output the private and public IPs of the instance

output "InstancePrivateIP" {
  value = ["${baremetal_core_instance.TFInstance.private_ip}"]
}

output "InstancePublicIP" {
  value = ["${baremetal_core_instance.TFInstance.public_ip}"]
}