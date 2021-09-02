
# ELK

- start from 2019/01/11
- [30天 Docker E.L.K stack](https://ithelp.ithome.com.tw/users/20103420/ironman/1046)
- [ELK x SRE （沒時間了，你快變成賽亞人吧）](https://ithelp.ithome.com.tw/articles/10236438)
- [Elastic Getting Started](https://www.elastic.co/guide/en/elastic-stack-get-started/current/index.html)
- [Logstash User Guide](https://www.elastic.co/guide/en/logstash/current/index.html)
- [Kibana User Guide](https://www.elastic.co/guide/en/kibana/current/index.html)
- ELK 問世以前的產品為 `splunk`, 要花 $$


## ELK in Docker

- [docker-elk專案](https://github.com/deviantony/docker-elk)



## Elasticsearch

- Apache License
- Cross platform (Java)
- Base on RestfulAPI 的 `High scalability` && `High abilability` 的 `real-time` Full-text search engine.
- Denormailization (json data type)
- base on `Lucene` : 全文檢索的框架 (作者是 Hadoop 的作者)
- **搜尋** 及 **分析工具**
- 最常被用來作 **Log Management**
- Distributed -> Scalable -> Big data
- 類似產品: Splunk 和 Solr(比ES慢, 但能處理更多資料格式)
- 預設使用 9200 port

ElasticSearch | RDBMS
------------- | ---------
Node          | Server
Index         | Database
Mapping/Type  | Table
Document      | Row
Field         | Column/Field
Mapping       | Schema
Shard         | Partition/Shard
(all indexed) | Index
Query DSL     | SQL
JSON Object   | Tuple




## Logstash

- 把來自不同系統的 `data送到 Elastic Search`
- 將前述的 `資料作格式化`
- 等候 `Beats(套件)` 傳資料進來, 使用 5044 port

```sh
### 檢查 Logstash 設定檔有沒有設錯
$# /usr/share/logstash/bin/logstash --path.settings /etc/logstash -t
# 預設會檢查 /etc/logstash/conf.d/*.conf
# 除非改寫 /etc/logstash/pipelines.yml
```


## Kibana

- `資料視覺化`
- 搜尋、分析的 UI
- 預設使用 5601 port


# Other Plugins

- Marvel(multicluster 版本需要付費) : Used for monitoring Elastic Search
    - 安裝: bin/plugin -i elasticsearch/marvel/latest
- Head   : Used for managing Elastic Search indexes
    - 安裝: bin/plugin -i mobz/elasticsearch-head
- Shield : Security for Elastic Search
    - 安裝: bin/plugin -i license; bin/plugin -i shield
    - NOT FREE
- Koph(only before ES v0.9,v1,v2) : Simple web administration tool for Elastic Search, it offers an easy way of performing common tasks on an ElasticSearch cluster.
    - 安裝: bin/plugin -i lmenezes/elasticsearch-kopf
        - 存取: http://localhost:9200/_plugin/kopf/
- Curator : Help remove old indices and optimize the system
    - pip install elasticsearch-curator

可看還有哪些 plugins : `bin/plugin -l`
