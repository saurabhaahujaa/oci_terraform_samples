
data "oci_identity_availability_domains" "test_availability_domains" {
    #Required
     compartment_id =var.compartment_ocid
}

resource "oci_core_instance" "oracle_instance" {
    # Required
    availability_domain = "${data.oci_identity_availability_domains.test_availability_domains.availability_domains[1].name}"
    compartment_id = var.compartment_ocid
    shape = "VM.Standard2.1"
    display_name="${var.environment}"
    create_vnic_details {
        assign_public_ip = true
        subnet_id = var.subnet_id
    }
source_details {
        source_id = "ocid1.image.oc1.iad.aaaaaaaageeenzyuxgia726xur4ztaoxbxyjlxogdhreu3ngfj2gji3bayda"
        source_type = "image"
     }
}