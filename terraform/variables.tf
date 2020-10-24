variable "lb_shape" {
  default = "10Mbps-Micro"
}

variable "lb_name" {
  default = "loadbalancer_geoserver"
}

variable "lb_is_private" {
  default = false
}

variable "lb_be_name" {
  default = "loadbalancer_geoserver_be"
}

variable "lb_be_policy" {
  default = "ROUND_ROBIN"
}

variable "lb_be_health_checker_port" {
  default = "8080"
}

variable "lb_be_health_checker_protocol" {
  default = "HTTP"
}

variable "lb_be_health_checker_regex" {
  default = ".*"
}

variable "lb_be_health_checker_urlpath" {
  default = "/geoserver/web/"
}

variable "lb_be_session_cookie" {
  default = "lb-session1"
}

variable "lb_be_session_fallback" {
  default = true
}

variable "lb_listener_name" {
  default = "ListenerGeoServer"
}

variable "lb_listener_port" {
  default = 8080
}

variable "lb_listener_protocol" {
  default = "HTTP"
}

variable "lb_listener_connection_configuration_idle_timeout" {
  default = "300"
}

variable "natgw_route_cidr_block" {
  default = "0.0.0.0/0"
}

variable "public_subnet_display_name" {
  default = "PublicSubnet"
}

variable "private_subnet_display_name" {
  default = "PrivateSubnet"
}

variable "public_subnet_dns_label" {
  default = "pub"
}

variable "private_subnet_dns_label" {
  default = "pri"
}

variable "private_prohibit_public_ip_on_vnic" {
  default = "true"
}

variable "public_sl_display_name" {
  default = "PublicSL"
}

variable "private_sl_display_name" {
  default = "PrivateSL"
}

variable "egress_destination" {
  default = "0.0.0.0/0"
}

variable "tcp_protocol" {
  default = "6"
}

variable "public_ssh_sl_source" {
  default = "0.0.0.0/0"
}

variable "public_http_sl_source" {
  default = "0.0.0.0/0"
}

variable "rule_stateless" {
  default = "false"
}

variable "public_sl_ssh_tcp_port" {
  default = "22"
}

variable "private_sl_ssh_tcp_port" {
  default = "22"
}

variable "private_sl_http_tcp_port" {
  default = "8080"
}

variable "public_sl_http_tcp_port" {
  default = "8080"
}


variable "instance_configuration_name_geoserever" {
  default = "GeoServerInstanceConfiguration"
}

variable "instance_configuration_type" {
  default = "compute"
}

variable "instance_configuration_vnic_details_assign_public_ip" {
  default = true
}

variable "instance_configuration_vnic_details_geoserver_name" {
  default = "GeoServerInstance"
}

variable "instance_configuration_vcnic_skip_source_dest_check" {
  default = false
}

variable "instance_configuration_source_details_source_type" {
  default = "image"
}

variable "operating_system" {
  default = "Oracle Linux"
}

variable "operating_system_version" {
  default = "7.8"
}


variable "instance_shape_name" {
  default = "VM.Standard.E2.1.Micro"
}
variable "source_type" {
  default = "image"
}

variable "assign_public_ip" {
  default = "true"
}

variable "instance_display_name" {
  default = "PublicServer"
}

variable "instance_create_vnic_details_hostname_label" {
  default = "public-1"
}

variable "is_monitoring_disabled" {
  default = false
}

variable "ssh_public_key_geoserver" {
  default = "Fill me out!"
}

variable "instance_pool_size" {
  default = 1
}

variable "instance_pool_state" {
  default = "RUNNING"
}

variable "instance_pool_name_geoserver" {
  default = "geoserver_pool"
}

variable "instance_pool_load_balancers_port" {
  default = "8080"
}

variable "instance_pool_load_balancers_vnic_selection" {
  default = "PrimaryVnic"
}

// AUTOSCALING VARIABLES
variable "autoscaling_cooldown_in_seconds" {
  default = "300"
}

variable "geoserver_autoscaling_name" {
  default = "geoserver_autoscaling"
}

variable "autoscaling_is_enabled" {
  default = true
}

variable "autoscaling_policies_initial" {
  default = "1"
}

variable "autoscaling_policies_max" {
  default = "2"
}

variable "autoscaling_policies_min" {
  default = "1"
}

variable "autoscaling_policy_geoserver_name" {
  default = "GeoServerScalingPolicy"
}

variable "autoscaling_type" {
  default = "threshold"
}

variable "autoscaling_rules_action_type_out" {
  default = "CHANGE_COUNT_BY"
}

variable "autoscaling_rules_action_value_out" {
  default = "1"
}

variable "autoscaling_rules_name_out" {
  default = "GeoserverScaleOut"
}

variable "autoscaling_rules_metric_type_out" {
  default = "CPU_UTILIZATION"
}

variable "autoscaling_rules_metric_threshold_operator_out" {
  default = "GT"
}

variable "autoscaling_rules_metric_threshold_value_out" {
  default = "10"
}

variable "autoscaling_rules_action_type_in" {
  default = "CHANGE_COUNT_BY"
}

variable "autoscaling_rules_action_value_in" {
  default = "-1"
}

variable "autoscaling_rules_name_in" {
  default = "GeoserverScaleIn"
}

variable "autoscaling_rules_metric_type_in" {
  default = "CPU_UTILIZATION"
}

variable "autoscaling_rules_metric_threshold_operator_in" {
  default = "LT"
}

variable "autoscaling_rules_metric_threshold_value_in" {
  default = "10"
}

variable "autoscaling_resources_type" {
  default = "instancePool"
}
