resource "oci_core_virtual_network" "terraform-vcn" {
  cidr_block     = var.VCN-terraform
  compartment_id = var.compartment_ocid
  display_name   = "terraform-vcn-custom-16"
  dns_label      = "terraformvcn"
}
# ------ Create a new Internet Gateway
resource "oci_core_internet_gateway" "terraform-ig" {
  compartment_id = var.compartment_ocid
  display_name   = "terraform-internet-gateway-16"
  vcn_id         = oci_core_virtual_network.terraform-vcn.id
}

# ------ Create a new Route Table
resource "oci_core_route_table" "terraform-rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.terraform-vcn.id
  display_name   = "terraform-route-table-16"
  route_rules {
    cidr_block        = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.terraform-ig.id
  }
}
# ------ Create a public subnet 1 in AD1 in the new VCN
resource "oci_core_subnet" "terraform-public-subnet1" {
  availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name")
  cidr_block          = "10.0.1.0/24"
  display_name        = "terraform-public-subnet1-16"
  dns_label           = "subnet1"
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.terraform-vcn.id
  route_table_id      = oci_core_route_table.terraform-rt.id
  dhcp_options_id     = oci_core_virtual_network.terraform-vcn.default_dhcp_options_id
}


