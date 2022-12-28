module "staging-coreinstance" {
  source             = "../../coreinstance"
  display_name       = "staginginstance"
  environment        = "staging"
  node_count         = 1
  node_type          = "ORACLELOGVM.Standard.E.2.1"
  availability_domain = ["FD3"]
  compartment_ocid    = var.compartment_ocid
  subnet_id           = var.subnet_id
}
