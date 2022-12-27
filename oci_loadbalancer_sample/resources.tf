/* Network */
resource "oci_core_virtual_network" "vcn-web" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "vcn-web-dj"
  dns_label      = "vcnweb"
}
resource "oci_core_security_list" "LB-Security-List" {
  display_name   = "LB-Security-List"
  compartment_id = oci_core_virtual_network.vcn-web.compartment_id
  vcn_id         = oci_core_virtual_network.vcn-web.id

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 80
      max = 80
    }
  }
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = "22"
      max = "22"
    }
  }
}
resource "oci_core_default_security_list" "default-securitylist" {
  manage_default_resource_id = oci_core_virtual_network.vcn-web.default_security_list_id
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
  ingress_security_rules {
    protocol = "6"
    source   = "10.0.0.0/24"
    tcp_options {
      min = 80
      max = 80
    }
  }
   ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = "22"
      max = "22"
    }
  }
}

resource "oci_core_default_route_table" "default-route-table" {
  manage_default_resource_id = oci_core_virtual_network.vcn-web.default_route_table_id
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internetgateway1.id
  }
}
resource "oci_core_internet_gateway" "internetgateway1" {
  compartment_id = var.compartment_ocid
  display_name   = "internetgateway1"
  vcn_id         = oci_core_virtual_network.vcn-web.id
}
resource "oci_core_route_table" "LB-Route-Table" {
  compartment_id = var.compartment_ocid
  display_name   = "routetable1"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internetgateway1.id
  }
  vcn_id = oci_core_virtual_network.vcn-web.id
}

resource "oci_core_subnet" "lb-subnet1" {
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain - 3], "name")
  cidr_block          = "10.0.0.0/24"
  display_name        = "lb-subnet1"
  dns_label           = "lbsubnet1"
  security_list_ids   = ["${oci_core_security_list.LB-Security-List.id}"]
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.vcn-web.id
  route_table_id      = oci_core_route_table.LB-Route-Table.id
  dhcp_options_id     = oci_core_virtual_network.vcn-web.default_dhcp_options_id
  provisioner "local-exec" {
    command = "sleep 5"
  }
}
resource "oci_core_subnet" "lb-subnet2" {
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain - 2], "name")
  cidr_block          = "10.0.1.0/24"
  display_name        = "lb-subnet2"
  dns_label           = "lbsubnet2"
  security_list_ids   = ["${oci_core_security_list.LB-Security-List.id}"]
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.vcn-web.id
  route_table_id      = oci_core_route_table.LB-Route-Table.id
  dhcp_options_id     = oci_core_virtual_network.vcn-web.default_dhcp_options_id
  provisioner "local-exec" {
    command = "sleep 5"
  }
}
resource "oci_core_subnet" "web-server" {
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain - 1], "name")
  cidr_block          = "10.0.2.0/24"
  display_name        = "web-server"
  dns_label           = "webserver"
  # security_list_ids = ["${oci_core_security_list.vcn-web.default_security_list_id}"]
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn-web.id
  # route_table_id = "${oci_core_route_table.vcn-web.default_route_id}"
  dhcp_options_id = oci_core_virtual_network.vcn-web.default_dhcp_options_id
  provisioner "local-exec" {
    command = "sleep 5"
  }
}
/* Instances */
resource "oci_core_instance" "websrv1" {
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain - 1], "name")
  compartment_id      = var.compartment_ocid
  display_name        = "websrv1"
  shape               = var.instance_shape
  subnet_id           = oci_core_subnet.web-server.id
  hostname_label      = "websrv1"
  metadata = {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }
  source_details {
    source_type = "image"
    source_id   = var.instance_image_ocid[var.region]
  }
}
resource "oci_core_instance" "websrv2" {
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain - 1], "name")
  compartment_id      = var.compartment_ocid
  display_name        = "websrv2"
  shape               = var.instance_shape
  subnet_id           = oci_core_subnet.web-server.id
  hostname_label      = "websrv2"
  metadata = {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }
  source_details {
    source_type = "image"
    source_id   = var.instance_image_ocid[var.region]
  }
}
/* Load Balancer oci_load_balancer_load_balancer */
resource "oci_load_balancer" "lb1" {
  shape          = "100Mbps"
  compartment_id = var.compartment_ocid
  subnet_ids = [
    "${oci_core_subnet.lb-subnet1.id}",
    "${oci_core_subnet.web-server.id}",
  ]
  display_name = "LB-Web-Servers"
}
resource "oci_load_balancer_backend_set" "lb-bes1" {
  name             = "lb-bes1"
  load_balancer_id = oci_load_balancer.lb1.id
  policy           = "ROUND_ROBIN"
  health_checker {
    port     = "80"
    protocol = "HTTP"
    url_path = "/"
  }
}
resource "oci_load_balancer_listener" "lb-listener1" {
  load_balancer_id         = oci_load_balancer.lb1.id
  name                     = "http"
  default_backend_set_name = oci_load_balancer_backend_set.lb-bes1.name
  port                     = 80
  protocol                 = "HTTP"
  connection_configuration {
    idle_timeout_in_seconds = "8"
  }
}
resource "oci_load_balancer_backend" "lb-be1" {
  load_balancer_id = oci_load_balancer.lb1.id
  backendset_name  = oci_load_balancer_backend_set.lb-bes1.name
  ip_address       = oci_core_instance.websrv1.private_ip
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}
resource "oci_load_balancer_backend" "lb-be2" {
  load_balancer_id = oci_load_balancer.lb1.id
  backendset_name  = oci_load_balancer_backend_set.lb-bes1.name
  ip_address       = oci_core_instance.websrv2.private_ip
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}
output "lb_public_ip" {
  value = ["${oci_load_balancer.lb1.ip_addresses}"]
}