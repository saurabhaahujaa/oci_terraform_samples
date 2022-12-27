resource "oci_core_instance" "oraclelinux_instance" {
  # Required
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  shape               = "VM.Standard2.1"
  source_details {
    source_id   = "ocid1.image.oc1.iad.aaaaaaaanxbmz7rm7tkopukbbahtcbcx45v5omusafwhjaenzf7tkcoq56qa"
    source_type = "image"
  }

  # Optional
  display_name = "oraclelinux-saurabh"
  create_vnic_details {
    assign_public_ip = true
    subnet_id        = var.subnet_id
  }
  metadata = {
    ssh_authorized_keys = file("${var.ssh-key-file}")
  }
  preserve_boot_volume = false
}

output "public-ip-for-compute-instance" {
  value = oci_core_instance.oraclelinux_instance.public_ip
}
