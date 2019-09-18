local redis = require "resty.redis"

return {
    fields = {
        redis_token_prefix = { type = "string", default = "" },
        redis_host = { type = "string" },
        redis_port = { type = "number", default = 6379 },
        redis_password = { type = "string" },
        redis_timeout = { type = "number", default = 2000 },
        token_secret = { type = "number", default = 1 },
	allow_anonymous = { type = "number", default = 0 },
    },
    self_check = function(schema, plugin_t, dao, is_updating)
        if not plugin_t.redis_host then
          return false, kong.response.exit(500, "You need to specify a Redis host")
        elseif not plugin_t.redis_port then
          return false, kong.response.exit(500, "You need to specify a Redis port")
        elseif not plugin_t.redis_timeout then
          return false, kong.response.exit(500, "You need to specify a Redis timeout")
        end

        local red = redis:new()
        red:set_timeout(plugin_t.redis_timeout)
        local ok, err = red:connect(plugin_t.redis_host, plugin_t.redis_port)
        if not ok then
          return false, kong.response.exit(500, "Redis Host unreachable: " .. err)
        end

        if plugin_t.redis_password and plugin_t.redis_password ~= "" then
          local ok, err = red:auth(plugin_t.redis_password)
          if not ok then
              return false, kong.response.exit(500, "Redis Invalid Credentials: " .. err)
          end
        end

        return true
    end
}
