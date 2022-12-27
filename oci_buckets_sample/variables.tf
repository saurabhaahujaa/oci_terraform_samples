# ---- use variables defined in terraform.tf vars or bash
# --profile file
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "AD" {}
variable "subnet_id" {}
variable "namespace" {}
variable "bucket_name" { }
#--- provider
provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}


data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}