output "lb_public_ip" {
  value = ["${baremetal_load_balancer.lb1.ip_addresses}"]
}

output "lb_id" {
  value = ["${baremetal_load_balancer.lb1.id}"]
}

output "lb_bes_id" {
  value = ["${baremetal_load_balancer_backendset.lb-bes1.id}"]
}
