module "production-coreinstance" {
  source             = "../../coreinstance"
  display_name       = "productioninstance"
  environment        = "production"
  node_count         = 1
  node_type          = "ORACLELOGVM.Standard.E.2.3"
  availability_domain = ["FD2"]
  compartment_ocid    = var.compartment_ocid
  subnet_id           = var.subnet_id
}