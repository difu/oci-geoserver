resource "oci_core_instance_configuration" "instance_configuration_geoserver" {
  compartment_id = var.compartment_ocid
  display_name   = var.instance_configuration_name_geoserever

  instance_details {
    instance_type = var.instance_configuration_type

    launch_details {
      compartment_id = var.compartment_ocid
      shape          = var.instance_shape_name
      display_name   = var.instance_configuration_name_geoserever

      create_vnic_details {
        assign_public_ip       = var.instance_configuration_vnic_details_assign_public_ip
        display_name           = var.instance_configuration_vnic_details_geoserver_name
        skip_source_dest_check = var.instance_configuration_vcnic_skip_source_dest_check
        nsg_ids = [
        ]
      }

      metadata = {
        ssh_authorized_keys = var.ssh_public_key_geoserver
        user_data           = base64encode(var.user-data)
      }

      shape_config {
        ocpus = 1
      }

      launch_mode                         = "PARAVIRTUALIZED"
      is_pv_encryption_in_transit_enabled = "false"
      preferred_maintenance_action        = "REBOOT"

      agent_config {
        is_management_disabled = false
        is_monitoring_disabled = false
      }

      source_details {
        source_type = var.instance_configuration_source_details_source_type
        #image_id    = lookup(data.oci_core_images.oraclelinux.images[0], "id")
        image_id = lookup(data.oci_core_images.geoserver_image.images[0], "id")
      }
      launch_options {
        boot_volume_type = ""
        firmware         = ""
        #is_consistent_volume_naming_enabled = <<Optional value not found in discovery>>
        #is_pv_encryption_in_transit_enabled = <<Optional value not found in discovery>>
        network_type            = "PARAVIRTUALIZED"
        remote_data_volume_type = ""
      }

    }
  }
}


resource "oci_core_instance_pool" "instance_pool_geoserver" {
  compartment_id            = var.compartment_ocid
  instance_configuration_id = oci_core_instance_configuration.instance_configuration_geoserver.id
  size                      = var.instance_pool_size
  state                     = var.instance_pool_state
  display_name              = var.instance_pool_name_geoserver

  placement_configurations {
    availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[2], "name")
    primary_subnet_id   = oci_core_subnet.public_subnet_3.id
  }

  load_balancers {
    #Required
    backend_set_name = oci_load_balancer_backend_set.public_lb_backend_set.name
    load_balancer_id = oci_load_balancer.public_loadbalancer.id
    port             = var.instance_pool_load_balancers_port
    vnic_selection   = var.instance_pool_load_balancers_vnic_selection
  }
}


resource "oci_autoscaling_auto_scaling_configuration" "auto_scaling_configuration_geoserver" {
  compartment_id       = var.compartment_ocid
  cool_down_in_seconds = var.autoscaling_cooldown_in_seconds
  display_name         = var.geoserver_autoscaling_name
  is_enabled           = var.autoscaling_is_enabled

  policies {
    capacity {
      initial = var.autoscaling_policies_initial
      max     = var.autoscaling_policies_max
      min     = var.autoscaling_policies_min
    }

    display_name = var.autoscaling_policy_geoserver_name
    policy_type  = var.autoscaling_type

    rules {
      action {
        type  = var.autoscaling_rules_action_type_out
        value = var.autoscaling_rules_action_value_out
      }

      display_name = var.autoscaling_rules_name_out

      metric {
        metric_type = var.autoscaling_rules_metric_type_out

        threshold {
          operator = var.autoscaling_rules_metric_threshold_operator_out
          value    = var.autoscaling_rules_metric_threshold_value_out
        }
      }
    }

    rules {
      action {
        type  = var.autoscaling_rules_action_type_in
        value = var.autoscaling_rules_action_value_in
      }

      display_name = var.autoscaling_rules_name_in

      metric {
        metric_type = var.autoscaling_rules_metric_type_in

        threshold {
          operator = var.autoscaling_rules_metric_threshold_operator_in
          value    = var.autoscaling_rules_metric_threshold_value_in
        }
      }
    }
  }

  auto_scaling_resources {
    id   = oci_core_instance_pool.instance_pool_geoserver.id
    type = var.autoscaling_resources_type
  }
}

variable "user-data" {
  default = <<EOF
#!/bin/bash -x
echo '################### Geoserver userdata begins #####################'
systemctl disable  firewalld
systemctl stop  firewalld
touch ~opc/userdata.`date +%s`.finish

export GEOSERVER_HOME=/opt/geoserver
su geoserver /opt/geoserver/bin/startup.sh

echo '################### Geoserver userdata ends #######################'
EOF
}

data "oci_core_images" "oraclelinux" {
  compartment_id = var.compartment_ocid

  operating_system         = var.operating_system
  operating_system_version = var.operating_system_version

  # exclude GPU specific images
  filter {
    name = "display_name"
    values = ["^([a-zA-z]+)-([a-zA-z]+)-([\\.0-9]+)-([\\.0-9-]+)$"]
    regex = true
  }
}

data "oci_core_images" "geoserver_image" {
  compartment_id = var.compartment_ocid

  display_name = "Geoserver"

//  filter {
//
//  }
}

//resource "oci_database_autonomous_database" "test_autonomous_database" {
//  #Required
//  compartment_id = var.compartment_ocid
//  cpu_core_count = 1
//  data_storage_size_in_tbs = 1
//  db_name = "ADB1"
//  is_free_tier = true
//  db_workload = "OLTP"
//  admin_password = ""
//}
