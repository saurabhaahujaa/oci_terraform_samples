module "dev" {
  source           = "./environments/dev"
  compartment_ocid = var.compartment_ocid
  subnet_id        = var.subnet_id
}

module "staging" {
  source           = "./environments/staging"
  compartment_ocid = var.compartment_ocid
  subnet_id        = var.subnet_id
}

module "production" {
  source           = "./environments/production"
  compartment_ocid = var.compartment_ocid
  subnet_id        = var.subnet_id
}