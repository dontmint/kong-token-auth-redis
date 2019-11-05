local redis = require "resty.redis"
local typedefs = require "kong.db.schema.typedefs"

return {
  name = "kong-token-auth-redis",
  fields = {
    { protocols = typedefs.protocols_http },
    { config = {
        type = "record",
        fields = {
          { token_secret = { type = "string" }, },
          { redis_token_prefix = { type = "string", default = "kong" }, },
          { redis_cluster = {
              type = "array",
              elements = {
                type = "record",
                fields = {
                  { ip = { type = "string" }, },
                  { port = { type = "number" }, },
                },
              },
            },
          },
        },
      },
    },
  },
}
