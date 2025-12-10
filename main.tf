module "https_auto_lb" {
  source = "./modules/https_auto_lb"
  providers = {
    volterra = volterra
  }
  lb_count   = var.lb_count
  namespace  = var.namespace
  tenant_url = var.tenant_url
  api_token  = var.api_token
  labels     = var.labels
  domains = var.domains
  cdn_cname             = module.cdn-distribution.lb_cname_list
  cdn_domain            = module.cdn-distribution.lb_cdn_domain_list
  depends_on            = [module.cdn-distribution, module.origin_pool]
  origin_pool_name_list = module.origin_pool.origin_pool_name_list

}

output "https_auto_lb_output" {
  value = module.https_auto_lb.cname

  description = "attributes of http auto lb"
}
# ${module.https_auto_lb.acme_challenge}

output "lb_list" {
  value       = module.https_auto_lb.lb-list
  description = "list of all LBs in namespace"
}

output "acme_challenge" {
  value = module.https_auto_lb.acme_challenge
}


module "cdn-distribution" {
  source    = "./modules/cdn-distribution"
  namespace = var.namespace
  domains   = var.cdn_domains
  labels = {
    "origin-type" = "cdn"
    "env"         = "uat"
  }
  tenant_url = var.tenant_url
  api_token  = var.api_token
}

output "cdn-lb-cnames" {
  value = module.cdn-distribution.lb_cname_list
}
output "cdn-lb-names" {
  value = module.cdn-distribution.lb_cdn_domain_list
}

# module "cdn-simple-route" {
#   source      = "./modules/cdn-simple-route"
#   cdn_domains = module.cdn-distribution.lb_cdn_domain_list
#   domains = var.domains
#   namespace = var.namespace
#   lb_count  = var.lb_count

# }

module "origin_pool" {
  source     = "./modules/origin_pool"
  namespace  = var.namespace
  cdn_cname  = module.cdn-distribution.lb_cname_list
  cdn_domain = module.cdn-distribution.lb_cdn_domain_list
  lb_count   = var.lb_count
  labels = {
    origin-type = "cdn"
    env         = "uat"
  }
}

output "flattened_domains" {
  value = module.https_auto_lb.flattened_domains
}

output "origin_pool_name_list" {
  value = module.https_auto_lb.origin_pool_name_list
}