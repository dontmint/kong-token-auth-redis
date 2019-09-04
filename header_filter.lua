local redis = require "resty.redis"

local _M = {}

function _M.execute(conf, ngx)

-- Get request Header and check if exist
  local ngx_headers = kong.request.get_headers()
  local auth, err = ngx_headers["Authorization"] 
  if not auth then
    ngx.log(ngx.ERR, ngx_headers["Authorization"])
    return
  end 
  
  local token 
  if string.len(conf.redis_token_prefix) > 0 then 
    token = conf.redis_token_prefix .. ":" .. string.sub(auth, 8) 
  end

-- Init Redis connection
  local red = redis:new() 
  red:set_timeout(conf.redis_timeout)
-- Connet to redis
  local ok, err = red:connect(conf.redis_host, conf.redis_port)
  if not ok then
    ngx.log(ngx.ERR, "failed to connect to Redis: ", err)
    return kong.response.exit(503, "Service Temporarily Unavailable")
  end

-- Auth Redis connection with password
  if conf.redis_password and conf.redis_password ~= "" then
    local ok, err = red:auth(conf.redis_password)
    if not ok then
      ngx.log(ngx.ERR, "failed to connect to Redis: ", err)
      return kong.response.exit(503, "Service Temporarily Unavailable")
    end
  end

-- Query token in Redis 
  local verify, err = red:get(token)
  if err then
    ngx.log(ngx.ERR, "error while fetching redis key: ", err)
    return kong.response.exit(503, "Service Temporarily Unavailable")
  end 
-- Debug message in Error log, development mode
--  if type(verify) == "string" then 
--    ngx.log(ngx.ERR, "VERIFY : " .. verify .. "TOKEN : " .. auth)
--  end

--  Verify Token secret with config 
  if verify == conf.token_secret then
    return
  else
    return kong.response.exit(403, "Token invalid")  
  end
  
-- Close Redis connection 
   local ok, err = red:close()
end

return _M