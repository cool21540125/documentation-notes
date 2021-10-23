
https://github.com/docker/awesome-compose



```yml
version: '3'

services:
    service1:
        extra_hosts:
            - "host1:172.16.33.101"
            - "host2:172.16.33.102"
        healthcheck:
            test: ["CMD", "curl", "-f", "http://localhost"]
            interval: 1m30s
            timeout: 10s
            retries: 3
            start_period: 40s
```