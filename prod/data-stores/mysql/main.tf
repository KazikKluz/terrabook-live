terraform {
  backend "s3" {
    key = "prod/data-stores/mysql/terraform.tfstate"
    bucket = "terraform-state-kazucha"
    region = "eu-west-1"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "mysql_cluster" {
    source = "github.com/KazikKluz/terrabook-modules//data-stores/mysql?ref=v0.0.1"
    db_name = "mysqlProd"
    db_password = var.pass
    db_username = var.user
}

output "db_address" {
  description = "test"
  value =  module.mysql_cluster.address
}

output "db_port" {
  description = "The port the database is listening on"
  value = module.mysql_cluster.port
}