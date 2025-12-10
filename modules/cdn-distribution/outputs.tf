output "lb_cname_list" {
  value = [for lb in local.all_lbs.items : lb.get_spec.service_domains[0].service_domain]
  #"domain:${lb.get_spec.service_domains[0].domain}\nservice_domain:${lb.get_spec.service_domains[0].service_domain}"]
}

output "lb_cdn_domain_list" {
  value = [for lb in local.all_lbs.items : lb.get_spec.service_domains[0].domain]

}