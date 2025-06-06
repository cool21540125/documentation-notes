# zabbix

- 2019/07/23
- 監控用的
  - written by go + PHP

## Ports

- 80: Web GUI
- 10050: Agent 要開, Server 會來訪問此 Port 撈資料 (Passive Agent)
- 10051: Server 要開, Agent 會送資料到此 Port (Active Agent)

# 結構

```bash
/etc/
    /zabbix/
        /zabbix-server.conf         # zabbix 設定主檔
/usr/share/zabbix/include/classes/api/services/     # api-history
```
