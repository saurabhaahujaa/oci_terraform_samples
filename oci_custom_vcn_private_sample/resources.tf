resource "oci_core_virtual_network" "terraform-vcn" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = "terraform-vcn-04"
  dns_label      = "terraformvcn04"
}
###--- Create a new NAT Gateway
resource "oci_core_nat_gateway" "terraform-NAT-gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "terraform-NAT-gateway"
  vcn_id         = oci_core_virtual_network.terraform-vcn.id
}
# ------ Create a new Internet Gateway
resource "oci_core_internet_gateway" "terraform-ig" {
  compartment_id = var.compartment_ocid
  display_name   = "terraform-internet-gateway"
  vcn_id         = oci_core_virtual_network.terraform-vcn.id
}
# ------ Create a new Route Table
resource "oci_core_route_table" "terraform-rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.terraform-vcn.id
  display_name   = "terraform-route-table"
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.terraform-ig.id
  }
}
resource "oci_core_route_table" "terraform-rt2" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.terraform-vcn.id
  display_name   = "terraform-route-table2"
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_nat_gateway.terraform-NAT-gateway.id
  }
}
# ------ Create a public subnet 1 in AD1 in the new VCN
resource "oci_core_subnet" "terraform-public-subnet1" {
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1], "name")
  cidr_block          = "10.0.1.0/24"
  display_name        = "terraform-public-subnet1"
  dns_label           = "subnet1"
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.terraform-vcn.id
  route_table_id      = oci_core_route_table.terraform-rt.id
  dhcp_options_id     = oci_core_virtual_network.terraform-vcn.default_dhcp_options_id
}
####Create a private subnet 1 in AD2 in the new VCN
resource "oci_core_subnet" "terraform-private-subnet1" {
  availability_domain        = lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1], "name")
  cidr_block                 = "10.0.0.0/24"
  display_name               = "terraform-private-subnet1"
  dns_label                  = "subnet2"
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_virtual_network.terraform-vcn.id
  route_table_id             = oci_core_route_table.terraform-rt2.id
  prohibit_public_ip_on_vnic = true
  dhcp_options_id            = oci_core_virtual_network.terraform-vcn.default_dhcp_options_id
}