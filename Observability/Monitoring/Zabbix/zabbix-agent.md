
分成 3 個部分:

- conf
- zabbix-agent2 (Zabbix5.0+)
- zabbix-agent

------------------------------------------------------

# conf

每次調整完組態, 都要記得重啟服務

```sh
/etc/zabbix/*.conf
/etc/zabbix/zabbix-agentd/*.conf
```

裡面可能會定義一些 `UserParameter`, 就需要 `systemctl restart zabbix-agent`


# zabbix-agent2

※ 注意事項

```bash
$# ps aux | grep -v grep | grep zabbix
zabbix   14438  0.2  0.8 804472 35644 ?        Ssl  Aug04  13:02 /usr/sbin/zabbix_agent2 -c /etc/zabbix/zabbix_agent2.conf
#↑↑↑↑↑ 用戶為 zabbix. 留意要執行的指令, ex: docker cli, 必須授予 zabbix 用戶來使用

$# usermod -aG docker zabbix
#              ↑↑↑↑↑↑ 不同 Distrubution OR 使用不同安裝方式 OR 不同版本, 此 GroupName 可能不同, 須留意 (之前好像有看過 dockerroot 的)

# 改完以後, 必須要重啟服務才能生效Orz
$# systemctl restart zabbix-agent2
```

```bash
### 可用來自行測試
$# zabbix_agent2 -t docker.ping
docker.ping                                   [s|1]
```



# zabbix-agent
