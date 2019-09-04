### INSTALL 

1. Install plugin
```
git clone https://github.com/dontmint/kong-token-auth-redis.git /usr/local/share/lua/5.1/kong/plugins/ 
cd /usr/local/share/lua/5.1/kong/plugins/kong-token-auth-redis
luarocks make
```
2. Enable Plugin in kong.conf

```
[root@kong]# cat /etc/kong/kong.conf
...
plugins = kong-token-auth-redis
...

[root@kong]# kong restart
```


### Example

```
curl -X POST http://kong:8001/[services/routes]/[services-id/route-id]/plugins \
    --data "name=kong-token-auth-redis" \
    --data "config.redis_token_prefix=Token" \
    --data "config.redis_host=127.0.0.1" \
    --data "config.redis_port=6379" \
    --data "config.redis_password=[redis password]" \
    --data "config.redis_timeout=2000" \
    --data "config.token_secret=secret"
```
