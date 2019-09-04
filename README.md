### Example

```
curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=" \
    --data "config.redis_token_prefix=<prefix>" \
    --data "config.redis_host=<redis_host>" \
    --data "config.redis_port=<redis_port>" \
    --data "config.redis_password=<redis_password>" \
    --data "config.redis_timeout=123456" \
    --data "config.token_secret=secret"
```
