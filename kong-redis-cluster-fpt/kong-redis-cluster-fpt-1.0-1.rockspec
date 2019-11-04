package = "kong-redis-cluster-fpt"
version = "1.0-1"
source = {
    url = "https://github.com/dontmint/kong-token-auth-redis.git"
}
description = {
    summary = "Openresty lua client for redis cluster",
    detailed = [[
        Openresty environment lua client with redis cluster support.
        This is a wrapper around the 'resty.redis' library with cluster discovery 
        and failover recovery support.
    ]],
    license = "Apache License 2.0"
}
dependencies = {
    "lua-resty-redis ~> 0.26.0 "
}
build = {
    type = "builtin",
    modules = {
        ["kong-redis-cluster-fpt"] = "lib/rediscluster.lua"
    }
}
