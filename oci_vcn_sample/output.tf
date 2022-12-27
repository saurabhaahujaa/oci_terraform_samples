output "all_domains" {
  value = data.oci_identity_availability_domains.test_availability_domains.availability_domains
}

output "domain_0" {
  value = lookup(data.oci_identity_availability_domains.test_availability_domains.availability_domains[0], "name")
}

output "vcn_id"{
  value = oci_core_vcn.test_vcn.id
}

output "vcn_name"{
  value = oci_core_vcn.test_vcn.display_name
}