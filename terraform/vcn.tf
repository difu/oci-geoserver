variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}

variable "vcn_cidr" {}
variable "vcn_name" {}

variable "dns_label" {}

provider "oci" {
  version          = ">= 3.0.0"
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = pathexpand(var.private_key_path)
  region           = var.region
}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}

module "vcn" {
  source  = "oracle-terraform-modules/vcn/oci"
  version = "1.0.3"

    region = var.region

  # general oci parameters
  compartment_id = var.compartment_ocid
  label_prefix   = "var_prefix"

  # vcn parameters
  internet_gateway_enabled = true
  nat_gateway_enabled      = false
  service_gateway_enabled  = false
#  tags                     = var.tags
  vcn_cidr                 = var.vcn_cidr
  vcn_dns_label            = var.dns_label
  vcn_name                 = var.vcn_name
}

resource "oci_core_subnet" "public_subnet_1" {
  availability_domain        = lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")
  cidr_block                 = cidrsubnet(var.vcn_cidr, 8, 0)
  display_name               = join("-", [var.public_subnet_display_name, lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")])
  dns_label                  = join("", [var.public_subnet_dns_label, "1"])
  compartment_id             = var.compartment_ocid
  vcn_id                     = module.vcn.vcn_id
  security_list_ids          = [oci_core_security_list.public_security_list.id]
  route_table_id             = oci_core_route_table.public_route_table.id
  #prohibit_public_ip_on_vnic = var.public_prohibit_public_ip_on_vnic
}

resource "oci_core_subnet" "public_subnet_2" {
  availability_domain        = lookup(data.oci_identity_availability_domains.ADs.availability_domains[1], "name")
  cidr_block                 = cidrsubnet(var.vcn_cidr, 8, 2)
  display_name               = join("-", [var.public_subnet_display_name, lookup(data.oci_identity_availability_domains.ADs.availability_domains[1], "name")])
  dns_label                  = join("", [var.public_subnet_dns_label, "2"])
  compartment_id             = var.compartment_ocid
  vcn_id                     = module.vcn.vcn_id
  security_list_ids          = [oci_core_security_list.public_security_list.id]
  route_table_id             = oci_core_route_table.public_route_table.id
  #prohibit_public_ip_on_vnic = var.public_prohibit_public_ip_on_vnic
}

resource "oci_core_subnet" "public_subnet_3" {
  availability_domain        = lookup(data.oci_identity_availability_domains.ADs.availability_domains[2], "name")
  cidr_block                 = cidrsubnet(var.vcn_cidr, 8, 4)
  display_name               = join("-", [var.public_subnet_display_name, lookup(data.oci_identity_availability_domains.ADs.availability_domains[2], "name")])
  dns_label                  = join("", [var.public_subnet_dns_label, "3"])
  compartment_id             = var.compartment_ocid
  vcn_id                     = module.vcn.vcn_id
  security_list_ids          = [oci_core_security_list.public_security_list.id]
  route_table_id             = oci_core_route_table.public_route_table.id
  #prohibit_public_ip_on_vnic = var.public_prohibit_public_ip_on_vnic
}

resource "oci_core_subnet" "private_subnet_1" {
  availability_domain        = lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")
  cidr_block                 = cidrsubnet(var.vcn_cidr, 8, 6)
  display_name               = var.private_subnet_display_name
  dns_label                  = var.private_subnet_dns_label
  compartment_id             = var.compartment_ocid
  vcn_id                     = module.vcn.vcn_id
  security_list_ids          = [oci_core_security_list.private_security_list.id]
#  route_table_id             = oci_core_route_table.CreatePrivateRouteTable.id
  dhcp_options_id            = module.vcn.default_dhcp_options_id
  prohibit_public_ip_on_vnic = var.private_prohibit_public_ip_on_vnic
}


resource "oci_core_route_table" "public_route_table" {
  compartment_id = var.compartment_ocid

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = module.vcn.internet_gateway_id
  }

  vcn_id       = module.vcn.vcn_id
  display_name = "Public Route Table"
}

//resource "oci_core_route_table" "CreatePrivateRouteTable" {
//  compartment_id = var.compartment_ocid
//
//  route_rules {
//    destination       = var.natgw_route_cidr_block
//    network_entity_id = module.vcn.nat_gateway_id
//  }
//
//  vcn_id       = module.vcn.vcn_id
//  display_name = "Private Route Table"
//}

resource "oci_core_security_list" "public_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = module.vcn.vcn_id
  display_name   = var.public_sl_display_name

  // Allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = var.egress_destination
    protocol    = var.tcp_protocol
  }

  // allow inbound ssh traffic from a specific port
  ingress_security_rules {
    protocol  = var.tcp_protocol         // tcp = 6
    source    = var.public_ssh_sl_source // Can be restricted for specific IP address
    stateless = var.rule_stateless

    tcp_options {
      // These values correspond to the destination port range.
      min = var.public_sl_ssh_tcp_port
      max = var.public_sl_ssh_tcp_port
    }
  }
    // allow inbound Geoserver traffic from a specific port
  ingress_security_rules {
    protocol  = var.tcp_protocol         // tcp = 6
    source    = var.public_geoserver_sl_source
    stateless = var.rule_stateless

    tcp_options {
      // These values correspond to the destination port range.
      min = var.public_geoserver_port
      max = var.public_geoserver_port
    }
  }

  ingress_security_rules {
    protocol  = var.tcp_protocol          // tcp = 6
    source    = var.public_http_sl_source // Can be restricted for specific IP address
    stateless = var.rule_stateless

    tcp_options {
      // These values correspond to the destination port range.
      min = var.public_sl_http_tcp_port
      max = var.public_sl_http_tcp_port
    }
  }
  ingress_security_rules {
    protocol  = var.tcp_protocol   // tcp = 6
    source    = var.vcn_cidr // open all ports for VCN CIDR and do not block subnet traffic
    stateless = var.rule_stateless
  }
}

resource "oci_core_security_list" "private_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = module.vcn.vcn_id
  display_name   = var.private_sl_display_name

  // Allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = var.egress_destination
    protocol    = var.tcp_protocol
  }

  // allow inbound traffic from VCN
  ingress_security_rules {
    protocol  = var.tcp_protocol   // tcp = 6
    source    = var.vcn_cidr // VCN CIDR as allowed source and do not block subnet traffic
    stateless = var.rule_stateless

    tcp_options {
      // These values correspond to the destination port range.
      min = var.private_sl_ssh_tcp_port
      max = var.private_sl_ssh_tcp_port
    }
  }
  ingress_security_rules {
    protocol  = var.tcp_protocol   // tcp = 6
    source    = var.vcn_cidr // open all ports for VCN CIDR and do not block subnet traffic
    stateless = var.rule_stateless

    tcp_options {
      // These values correspond to the destination port range.
      min = var.private_sl_http_tcp_port
      max = var.private_sl_http_tcp_port
    }
  }
}


