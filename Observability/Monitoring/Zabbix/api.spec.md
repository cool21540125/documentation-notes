

```bash
### Send Request
ZBX=
curl -X POST http://${ZBX}/api_jsonrpc.php \
  -H 'Content-Type: application/json-rpc' \
  -d '{"jsonrpc":"2.0","method":"apiinfo.version","id":1,"auth":null,"params":{}}'

### Returned Response:
{"jsonrpc":"2.0","result":"4.0.28","id":1}
```


# 怪異問題 Q&A

- 明確指定 output 欄位, 卻只拿到 "itemid"
  - list of fileds 只對 Alert, DCheck, Host, DService, Screenitem, Template and Trigger get methods 有作用
  - https://www.zabbix.com/forum/zabbix-troubleshooting-and-problems/25384-zabbix-json-api-output-parameter



# history

- [history object](https://www.zabbix.com/documentation/4.0/manual/api/reference/history/object)
- [history - get](https://www.zabbix.com/documentation/4.0/manual/api/reference/history/get)

table        | description
------------ | ------------
history      | Double
history_log  | Log
history_str  | Str
history_text | Text
history_unit | Integer

```js
// 以 history 為例
{
  "jsonrpc": "2.0",
  "result": [
    {
      "itemid": "23296",
      "clock": "1564400116",    // 收到資料的時間
      "value": "0.0250",
      "ns": "155120900"         // 收到資料的 Nanoseconds
    }
  ]
}
```



```js
{
    "jsonrpc": "2.0",           // 似乎是 API 版本
    "method": "host.get",       // 特定資源點的 get, create, update, delete
    //"params": {},             //
    "params": {
        //"countOutput": true,      // true: 僅列出查詢筆數; 預設為 false
        "output": [                 // 要 select 的欄位
            "hostid",
            "host"
        ],
        "selectInterfaces": [
            "interfaceid",
            "ip"
        ],
        "search": {                 // 僅列出 特定欄位(key_) 裏頭有包含關鍵字(system)
            "key_": "system",           // 「where key_ like '%system%'」
        },
        "filter": {                 // 僅列出 完全相等的資料
            "history": "1w"             // 「where history = '1w'」
        }
    },
    "id": "",
    "auth": ""
}
```

