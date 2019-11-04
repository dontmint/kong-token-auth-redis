### INSTALL 

This plugin use to Authenticate request using Redis as a **Token Store/Source** of true.
I make 2 branches `master` and `redis-cluster`. If you only have 1 Redis instance, use `master`, It should work fine.
If you have a Redis cluster, please clone this Repo with option `-b redis-cluster` and follow instruction bellow.

> PLEASE NOTE THIS INSTRUCTION IS FOR BRANCH `REDIS-CLUSTER` ONLY

> TODO: 

> - Make `schema.lua` configed with all cluster hosts, currently, It can only using 1 hosts.

1. Install dependencies and plugin
```
git clone -b redis-cluster https://github.com/dontmint/kong-token-auth-redis.git 
cd kong-token-auth-redis/kong-redis-cluster-fpt
make 
luarocks make 
cd ..
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
http --form POST 'http://kong:8001/[services/routes]/[services-id/route-id]/plugins' \
  name=kong-token-auth-redis \
  config.redis_token_prefix=Token \
  config.redis_host=127.0.0.1 \
  config.redis_port=6379 \
  config.redis_password='[redis password]' \
  config.redis_timeout=2000 \
  config.token_secret=secret
```

Create Token 

```
redis-cli -c set Token:[Token_id] secret
```

Example Valid Token

```
root@kong02 local-redis]# http GET http://127.0.0.1:8000/get Authorization:"Bearer 89571834658geafg87g28qwgrigiasfd"
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Encoding: gzip
Content-Length: 244
Content-Type: application/json
Date: Tue, 03 Sep 2019 09:25:20 GMT
Referrer-Policy: no-referrer-when-downgrade
Server: nginx
Via: kong/1.3.0rc1
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-Kong-Proxy-Latency: 11
X-Kong-Upstream-Latency: 528
X-XSS-Protection: 1; mode=block

{
    "args": {},
    "headers": {
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate",
        "Authorization": "Bearer 89571834658geafg87g28qwgrigiasfd",
        "Host": "httpbin.org",
        "User-Agent": "HTTPie/1.0.3",
        "X-Forwarded-Host": "127.0.0.1"
    },
    "origin": "10.9.3.254, 127.0.0.1, 10.9.3.254",
    "url": "https://127.0.0.1/get"
}

```

Invalid Token 

```
[root@kong02 kong-redis-session]# http GET http://127.0.0.1:8000/get Authorization:"Bearer 89571834658geafg87g28qwgrigiasfd735y9hdf"
HTTP/1.1 403 Forbidden
Connection: keep-alive
Content-Length: 13
Date: Tue, 03 Sep 2019 09:09:00 GMT
Server: kong/1.3.0rc1

Token invalid
```

Redis Database down 

```
[root@kong02 local-redis]# http GET http://127.0.0.1:8000/get Authorization:"Bearer 89571834658geafg87g28qwgrigiasfd264fasdfasdfasdfasdfasdfas"
HTTP/1.1 503 Service Temporarily Unavailable
Connection: keep-alive
Content-Length: 31
Date: Tue, 03 Sep 2019 09:18:43 GMT
Sever: kong/1.3.0rc1

Service Temporarily Unavailable
```

