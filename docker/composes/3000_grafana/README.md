# Grafana

- [Grafana Plugin](https://grafana.com/grafana/plugins/)


```bash
docker run -d \
    --name graf \
    -p 3000:3000 \
    grafana/grafana:7.5.7
```

## PluginIn Usage

### Step1

```bash
### ex: 安裝 Zabbix Plugin
docker exec -t graf grafana-cli plugins install alexanderzobnin-zabbix-app
docker restart graf
```

### Step2

Web > Configuration > Plugins > Zabbix > Enable

### Step3

Web > Configuration > Data Sources > Zabbix
