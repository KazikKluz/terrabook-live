output "lb_dns_address" {
    description = "The address of the load balancer"
    value = module.webserver_cluster.alb_dns_name
}