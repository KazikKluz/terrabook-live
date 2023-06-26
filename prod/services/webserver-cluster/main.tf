terraform {
  backend "s3" {
    bucket = "terraform-state-kazucha"
    key = "prod/services/webserver-cluster/terraform.tfstate"
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

    cluster_name = "webservers-prod"
    db_remote_state_bucket = "terraform-state-kazucha"
    db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"

    instance_type = "m4.large"
    min_size = 2
    max_size = 10
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size = 2
  max_size = 10
  desired_capacity = 10
  recurrence = "0 9 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  min_size = 2
  max_size = 10
  desired_capacity = 2
  recurrence = "0 17 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}