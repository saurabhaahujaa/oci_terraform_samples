resource "oci_core_vcn" "test_vcn" {
  #Required
  compartment_id = var.compartment_ocid

  cidr_block    = "10.0.0.0/16"
  display_name  = var.vcn_display_name
  freeform_tags = { "Department" = "Finance" }
}