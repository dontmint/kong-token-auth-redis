package = "redis-token-verify"
version = "0.0.1-0"
source = {
  url = "https://github.com/dontmint/kong-token-redis-verify.git"
}
description = {
  summary = "A Kong plugin that Authorize access token using Redis as a token datastore",
  license = "Apache V2"
}
dependencies = {
  "lua ~> 5.1",
  "lua-resty-redis ~> 0.26.0"
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.redis-token-verify.handler"] = "handler.lua",
    ["kong.plugins.redis-token-verify.schema"] = "schema.lua",
    ["kong.plugins.redis-token-verify.header_filter"] = "header_filter.lua",
  }
}
