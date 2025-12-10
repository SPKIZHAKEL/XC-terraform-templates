module "https_custom_lb" {
  source = "./modules/https_custom_lb"
  providers = {
    volterra = volterra
  }
  lb_count   = var.lb_count
  namespace  = var.namespace
  tenant_url = var.tenant_url
  api_token  = var.api_token
  labels     = var.labels
  domains = [["test9.spkdemo.xyz",
    "test11.spkdemo.xyz"], ["test10.spkdemo.xyz",
  "test12.spkdemo.xyz"]]

}

output "https_custom_lb_output" {
  value = module.https_custom_lb.cname

  description = "attributes of http custom lb"
}


output "custom_lb_list" {
  value       = module.https_custom_lb.lb-list
  description = "list of all LBs in namespace (custom output)"
}


output "custom_flattened_domains" {
  value = module.https_auto_lb.flattened_domains
}

