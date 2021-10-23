
# 透過 Docker 安裝 RabbitMQ

- 2020/03/26
- [docker-RabbitMQ](https://hub.docker.com/_/rabbitmq)


```bash
### 2020/03/26, latest management 為 rabbitmq:3.8.3-management
### 2021/02/04, latest management 為 rabbitmq:3.8.11-management
$# docker pull rabbitmq:management

MQ_USER=demo
MQ_PASSWD=1234
$# docker run -d \
    -p 5672:5672 \
    -p 15672:15672 \
    -p 15674:15674 \
    -v  ~/docker_data/rabbitmq:/var/lib/rabbitmq \
    -e RABBITMQ_DEFAULT_USER=${MQ_USER} \
    -e RABBITMQ_DEFAULT_PASS=${MQ_PASSWD} \
    --hostname mymq \
    --name mymq \
    rabbitmq:management
# 管理介面 localhost:15672
# 資料傳輸 localhost:5672

### 查看 log
$# docker logs mymq -f
```


## RabbitMQ Notes

- NodeName 即為 hostname (這還蠻重要的, 總之記得宣告 hostname 就是了)
- 5672 port 是 RabbitMQ 用來傳輸用的
- 15672 為 RabbitMQ 管理介面位置
