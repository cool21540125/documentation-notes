# Prometheus

```bash
### Docker Container Monitoring
docker network create --subnet 192.168.200.0/24 net_monitoring
```

```

    cadvisor    <---------    prometheus    -------->    alertmanager
       
       |
       | auto discovery
       |
       | collect metrics
       |
       v

    docker containers

```


# prometheus 的配置文件

- config/prometheus.yml
    - 配置主檔
- config/web.yml
    - 與 Web UI 相關的配置文件 (帳密為 admin xxxxxxxx)

