resource "oci_objectstorage_bucket" "bucket1" {
  compartment_id = var.compartment_ocid
  namespace      = var.namespace
  name           = var.bucket_name
  access_type    = "NoPublicAccess"
}
resource "oci_objectstorage_preauthrequest" "test_preauthenticated_request" {
  #Required
  access_type  = "AnyObjectWrite"
  bucket       = var.bucket_name
  name         = "terraform-preauth-sauahuja"
  namespace    = var.namespace
  time_expires = "2022-12-30T00:09:51.000+02:00"
  #Optional
}

output "print_uri" {
  value = oci_objectstorage_preauthrequest.test_preauthenticated_request.access_uri
}
