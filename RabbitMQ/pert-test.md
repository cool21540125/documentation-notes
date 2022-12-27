
# 用來壓測 RabbmtMQ 的工具 : perf-test

- [RabbitMQ PerfTest](https://rabbitmq.github.io/rabbitmq-perf-test/stable/htmlsingle/)


```bash
### Help
$# docker run -it --rm pivotalrabbitmq/perf-test:latest --help


### 
# RabbiqMQ Java client 每條連線每秒可達到 80-90K 則訊息
$# MQ_USER=
$# docker run -it --rm \
    pivotalrabbitmq/perf-test:latest \
    -x ${N_of_Publishers} \
    -y ${N_of_Consumers} \
    -u "${MQ_USER}" \
    -a \
    --id "${ID}"
    -s ${N_of_Message_Size}
# -s: Message Size. 預設 12 bytes, 4000 表示 4kB
# 


### 
```


