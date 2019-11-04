-- local redis = require "resty.redis"

local redis = require "kong-redis-cluster-fpt"

local _M = {}

function _M.execute(conf, ngx)

local config = {
    name = "Cluster",                       --rediscluster name
    dict_name = "kong_locks",  
    enableSlaveRead = true,
    serv_list = {                           --redis cluster node list(host and port),
      { ip = conf.redis_host , port = conf.redis_port },
    },
    keepalive_timeout = 60000,              --redis connection pool idle timeout
    keepalive_cons = 1000,                  --redis connection pool size
    connection_timout = 1000,               --timeout while connecting
    max_redirection = 5,                    --maximum retry attempts for redirection
  }

-- Get request Header and check if exist
  local ngx_headers = kong.request.get_headers()
  local auth, err = ngx_headers["Authorization"] 
  if not auth and conf.allow_anonymous == 0 then -- 1 = Allow anonymous forward request, 0 = Disallow, return 401 as default
    return kong.response.exit(401, "Unauthorized Error")
  end 

  if not auth and conf.allow_anonymous == 1 then
    kong.service.request.clear_header("Authorization")
    return
  end

-- Init Redis connection
  local red = redis:new(config) 
  red:set_timeout(conf.redis_timeout)
 
--[[
-- Connet to redis
  if string.match(conf.redis_host, "[unix:/^]") then
    local ok, err = red:connect(conf.redis_host)
    if not ok then
      return kong.response.exit(503, "Service Temporarily Unavailable")
    end
  else
    local ok, err = red:connect(conf.redis_host, conf.redis_port)
    if not ok then
      return kong.response.exit(503, "Service Temporarily Unavailable")
    end
  end
]]

-- Auth Redis connection with password
  if conf.redis_password and conf.redis_password ~= "" then
    local ok, err = red:auth(conf.redis_password)
    if not ok then
      return kong.response.exit(503, "Service Temporarily Unavailable")
    end
  end

-- Query token in Redis 
  local token 
  if string.len(conf.redis_token_prefix) > 0 then 
    token = conf.redis_token_prefix .. ":" .. string.sub(auth, 8)
  else
    token = string.sub(auth, 8)
  end

  local verify, err = red:exists(token)
  if err then
    return kong.response.exit(503, "Service Temporarily Unavailable")
  end 

-- Keep Established Redis connection 
  local ok, err = red:set_keepalive(60000,5000)
      if not ok then
        kong.log.err("failed to set Redis keepalive: ", err)
      end

--  Verify Token secret with config 
  if tostring(verify) == tostring(conf.token_secret) then
    return
  elseif conf.allow_anonymous == 1 then
    kong.service.request.clear_header("Authorization")
    return
  else 
    return kong.response.exit(403, "Token invalid")  
  end
  
--   Close Redis connection 
--   local ok, err = red:close()
end

return _M
