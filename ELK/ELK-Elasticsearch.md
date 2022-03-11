# ElasticSearch

- 2019/01/16
- ElasticSearch: v6.5.4
- java: v1.8.0_161
- [ElasticSearch Plugins](https://www.elastic.co/guide/en/elasticsearch/plugins/current/index.html)

### vscode 外掛

- Elasticsearch for VSCode
- Elasticsearch Developer tool


## Config

```sh
### ES 目錄位置
/etc
    /elasticsearch
        /elasticsearch.keystore	    #
        /elasticsearch.yml	        # 設定主檔
        /jvm.options	            # JVM 相關設定(含 Memory)
        /log4j2.properties	        # Logging 機制設定
        /role_mapping.yml	        # ES role
        /roles.yml	                #
        /users	                    #
        /users_roles	            #


### 設定主檔
$# vim /etc/elasticsearch/elasticsearch.yml
# ------------- Context -------------
cluster.name: os7-Cluster                               # 此 Cluster 名稱
node.name: node-1	                                    # 此 ElasticSearch Node 名稱
node.attr.rack: r1	                                    #
path.data: /var/lib/elasticsearch	                    # Data 路徑
path.logs: /var/log/elasticsearch	                    # Log 路徑
network.host: 0.0.0.0	                                # 不限定存取來源
http.port: 9200	                                        # 服務窗口
discovery.zen.ping.unicast.hosts: ["host1", "host2"]    # 預設為「["127.0.0.1", "[::1]"]」; 新加入的 node, 初始化時要找尋的 hosts
gateway.recover_after_nodes: 3	                        # Cluster 重啟之後, 直到 N 個節點啟動後, 才開始作 recovery
action.destructive_requires_name: true	                #
# ------------- Context -------------

### JVM 資源問題 (There is insufficient memory for the Java Runtime Environment to continue...)
$# vim /etc/elasticsearch/jvm.options
-Xms512m        # 原為 -Xms1g, 調小一點
-Xmx512m        # 原為 -Xmx1g, 調小一點
```

### log4j2

方便 Programmer 在 Code 中加入 logging , 並輸出到 目標裝置

- 目標裝置: console, file, streaming, tcp, syslog, ...
- 5 種 Logging Level: DEBUG, INFO, WARN, ERROR, FATAL

具備 3 大元件:
- Logger   : Programmer 在程式中使用來作 logging 的元件
- Appender : 將 Log Message 輸出到各個裝置
- Layout   : Log Message 格式



### 設定主檔 elasticsearch.yml

分為 8 大部分:
1. Cluster   : Cluster 名稱
2. Node      : Master/Slave 名稱
3. Paths     : 資料位置
4. Memory    : 資源配置
5. Network   : Bind addresses
6. Discovery : 新加入的 node, 初始化時要找尋的 hosts
7. Gateway   : Cluster 重啟之後, 直到 N 個節點啟動後, 才開始作 recovery
8. Various   : (其他)




### ElasticSearch

```sh
### 健康狀態
http://192.168.124.118:9200/_cat/indices?v
$# curl http://localhost:9200/_cat/health?v     # 確認 es 整體健康狀況
$# curl http://localhost:9200/_cat/indices?v    # 確認 index 目錄狀況
health status index    uuid                   pri rep docs.count docs.deleted store.size pri.store.size
yellow open   customer p4An8JtFQ_aPbiMgOOoWJw   5   1          0            0      1.1kb          1.1kb
# pri       5       5 primary shards
# rep       1       1 replica(the defaults)
# docs.cont 0       0 documents

# Green - everything is good (cluster is fully functional)
# Yellow - all data is available but some replicas are not yet allocated (cluster is fully functional) 資料還沒作好 HA
# Red - some data is not available for whatever reason (cluster is partially functional)
```

```sh
### bulk
# https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started-batch-processing.html

curl -X POST "localhost:9200/data2/_doc/_bulk?pretty" -H 'Content-Type: application/json' -d'
{"index":{"_id":"1"}}
{"name": "John Doe" }
{"index":{"_id":"2"}}
{"name": "Jane Doe" }
'
```

# API


> curl -XGET http://<HOST>:<PORT>/_cat/XXX?YYY

XX         | Description
----------- | ---------------
health      | Cluster 狀態
indices     | Index 狀態
thread_pool | Thread 狀態
nodes       | Nodes 狀態

YYY         | Description
----------- | ---------------
v           | 詳細資訊
help        | 回傳結果欄位說明



