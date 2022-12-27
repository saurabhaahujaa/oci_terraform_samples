data "oci_identity_availability_domains" "test_availability_domains" {
  #Required
  compartment_id = var.compartment_ocid
}
