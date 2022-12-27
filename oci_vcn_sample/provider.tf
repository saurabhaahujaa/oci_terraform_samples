provider "oci" {

  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = ""
  fingerprint      = ""
  private_key_path = "/root/.oci/oci_private_key.pem"
  region           = "us-ashburn-1"
}