terraform {
  backend "http" {
    address       = "https://objectstorage.us-ashburn-1.oraclecloud.com/xxxxxxxxxxx/b/terraform-example-bucket-sauahuja/o/terraform.tfstate"
    update_method = "PUT"
  }
}