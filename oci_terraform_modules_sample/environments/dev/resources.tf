module "dev-coreinstance" {
  source              = "../../coreinstance"
  display_name        = "devinstance"
  environment         = "dev"
  node_count          = 1
  node_type           = "ORACLELOGVM.Standard.E.2.2"
  availability_domain = ["FD1"]
  compartment_ocid    = var.compartment_ocid
  subnet_id           = var.subnet_id
}
