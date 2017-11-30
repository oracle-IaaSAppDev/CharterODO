resource "baremetal_load_balancer" "lb1" {
  shape           = "100Mbps"
  compartment_id  = "${var.compartment_ocid}"
  subnet_ids      = ["${var.Subnet1OCID}", "${var.Subnet2OCID}"]
  display_name    = "${var.campaign_name}"
}

resource "baremetal_load_balancer_backendset" "lb-bes1" {
  name             = "lb-bes1"
  load_balancer_id = "${baremetal_load_balancer.lb1.id}"
  policy           = "ROUND_ROBIN"

  health_checker {
    port     = "8101"
    protocol = "TCP"
    response_body_regex = ".*"
    url_path = "/OrderManagement/"
  }
}

resource "baremetal_load_balancer_listener" "lb1_listener1" {
  load_balancer_id          = "${baremetal_load_balancer.lb1.id}"
  name                      = "HTTP_LISTENER"
  default_backend_set_name  = "${baremetal_load_balancer_backendset.lb-bes1.id}"
  port                      = 8001
  protocol                  = "HTTP"

}

resource "baremetal_load_balancer_listener" "lb1_listener2" {
  load_balancer_id          = "${baremetal_load_balancer.lb1.id}"
  name                      = "HTTPS_LISTENER"
  default_backend_set_name  = "${baremetal_load_balancer_backendset.lb-bes1.id}"
  port                      = 8002
  protocol                  = "HTTP"

}

