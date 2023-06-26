terraform {
  backend "s3" {
    bucket = "terraform-state-kazucha"
    key = "stage/services/webserver-cluster/terraform.tfstate"
    region = "eu-west-1"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true

  }
}

provider "aws" {
  region = "eu-west-1"
}

module "webserver_cluster" {
    source = "../../../../modules/services/webserver-cluster"

    cluster_name = "webservers-stage"
    db_remote_state_bucket = "terraform-state-kazucha"
    db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"

    instance_type = "t2.micro"
    min_size = 2
    max_size = 2
}

output "dns_address" {
  description = "address of the load ballancer"
  value = module.webserver_cluster.alb_dns_name
}


