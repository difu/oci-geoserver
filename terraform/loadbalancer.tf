resource "oci_load_balancer" "public_loadbalancer" {
  shape          = var.lb_shape
  compartment_id = var.compartment_ocid

  subnet_ids = [
    oci_core_subnet.public_subnet_1.id,
    oci_core_subnet.public_subnet_2.id,
  ]

  display_name = var.lb_name
  is_private   = var.lb_is_private
}

resource "oci_load_balancer_backend_set" "public_lb_backend_set" {
  name             = var.lb_be_name
  load_balancer_id = oci_load_balancer.public_loadbalancer.id
  policy           = var.lb_be_policy

  health_checker {
    port                = var.lb_be_health_checker_port
    protocol            = var.lb_be_health_checker_protocol
    response_body_regex = var.lb_be_health_checker_regex
    url_path            = var.lb_be_health_checker_urlpath
  }

  session_persistence_configuration {
    cookie_name      = var.lb_be_session_cookie
    disable_fallback = var.lb_be_session_fallback
  }
}
resource "oci_load_balancer_listener" "listener_public_lb" {
  load_balancer_id         = oci_load_balancer.public_loadbalancer.id
  name                     = var.lb_listener_name
  default_backend_set_name = oci_load_balancer_backend_set.public_lb_backend_set.name

  port     = var.lb_listener_port
  protocol = var.lb_listener_protocol

  connection_configuration {
    idle_timeout_in_seconds = var.lb_listener_connection_configuration_idle_timeout
  }
}