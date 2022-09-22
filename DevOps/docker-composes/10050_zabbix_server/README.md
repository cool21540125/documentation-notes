

```.env
### Necessary
USER_PASSWORD=
MYSQL_ROOT_PASSWORD=

# zabbix_web title
ZBX_SERVER_NAME=

# ElasticSearch
# ZBX_HISTORYSTORAGEURL=
# ZBX_HISTORYSTORAGETYPES=
```


```bash
docker run -d \
    --name zabbix_agent \
    -e ZBX_HOSTNAME="demo agent" \
    -e ZBX_SERVER_HOST="zabbix_server" \
    zabbix/zabbix-agent:centos-4.0.27
```