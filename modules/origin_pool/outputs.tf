output "origin_pool_name_list" {
  value = [for origin in volterra_origin_pool.cdn-origin-pool : origin.name]
}