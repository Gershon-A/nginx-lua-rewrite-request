## Reverse proxy
```
cd nginx-lua-request-capture
docker-compose -f docker-compose.yml up -d
```
## logger 
```
cd logger
docker-compose -f docker-compose-loger.yml up -d
```
## Send request 
```
curl -i http://localhost:8082/foo5  -H 'content-type: application/json'   -d '{    "level":"INFO",    "source":"Gershon",    "message":"Received response 404",    "client_secret":"secret",    "user_key":"my_key" }'
```
## How Tested:
1) 
```curl -i http://localhost:8082/foo5  -H 'content-type: application/json'   -d '{    "level":"INFO",    "source":"Gershon",    "message":"Received response 404",       "client_secret":"secret",    "user_key":"my_key" }'```

`http://localhost:8082` - nginx that acts as a reverse proxy to another nginx that acts as `logger` 

2) 
`http://localhost:8082` nginx rewrite body request and append additional data `"client_ip":"172.19.0.1"` before sending to destination (`logger`)

3) 
The request received at the end (`logger`):
```
"body":"{\"user_key\":\"my_key\",\"client_ip\":\"172.19.0.1\",\"message\":\"Received response 404\",\"level\":\"INFO\",\"source\":\"Gershon\",\"client_secret\":\"secret\"}"
```