variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "AD" {}
#--- provider
provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}
# -------- get the list of available ADs
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}
# ------ Create a new VCN
variable "vcn_cidr" { default = "10.0.0.0/16" }
