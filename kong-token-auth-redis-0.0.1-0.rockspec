package = "kong-token-auth-redis"
version = "0.0.1-0"
source = {
  url = "https://github.com/dontmint/kong-token-auth-redis.git"
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
    ["kong.plugins.kong-token-auth-redis.handler"] = "handler.lua",
    ["kong.plugins.kong-token-auth-redis.schema"] = "schema.lua",
    ["kong.plugins.kong-token-auth-redis.header_filter"] = "header_filter.lua",
  }
}
