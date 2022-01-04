# kafka

- 2021/12/28
- [Docker - bitnami/kafka](https://hub.docker.com/r/bitnami/kafka/)
- [Docker - zookeeper](https://hub.docker.com/_/zookeeper)
- kafka 依賴 zookeeper... 所以不得不提到它
- 資料從給定 partition 的 Leader 寫入/讀取


## Getting Start

- [Getting Started](https://kafka.apache.org/documentation/#quickstart)

```bash
### 必須要有 java8+
### 前往下載 Kafka: https://downloads.apache.org/kafka/
### ex: https://www.apache.org/dyn/closer.cgi?path=/kafka/3.0.0/kafka_2.13-3.0.0.tgz
cd /usr/local/src
tar -xzf kafka_2.13-3.0.0.tgz
cd kafka_2.13-3.0.0


### 啟動 zookeeper (將來某個版本後, kafka 將不再需要 zookeeper)
$# bin/zookeeper-server-start.sh \
    config/zookeeper.properties


### 啟動 kafka broker
$# bin/kafka-server-start.sh \
    config/server.properties

# ↑ 完成基本 kafka 環境建置 (可開始使用)


### 建立 topic , 用來儲存 event / record / message
$# bin/kafka-topics.sh \
    --crete \
    --partitions 1 \
    --replication-factor 1 \
    --topic quickstart-events \
    --bootstrap-server localhost:9092
# 寫入 event 以前, 必須要有 topic


### 查詢 topic 相關資訊
$# bin/kafka-topics.sh \
    --describe \
    --topic quickstart-events \
    --bootstrap-server localhost:9092
Topic:quickstart-events  PartitionCount:1    ReplicationFactor:1 Configs:
    Topic: quickstart-events Partition: 0    Leader: 0   Replicas: 0 Isr: 0


### Write to Topic (kafka client, write event to broker)
$# bin/kafka-console-producer.sh \
    --topic quickstart-events \
    --bootstrap-server localhost:9092
> (亂打一堆東西)
> 使用「ctrl + c」 來中斷


### Read from Topic (kafka client, read from broker)
$# bin/kafka-console-consumer.sh \
    --topic quickstart-events \
    --from-beginning \
    --bootstrap-server localhost:9092
# --from-beginning : 指定 offset 從頭開始


### 效能測試
$# bin/kafka-producer-perf-test.sh \
    --topic quickstart-events \
    --num-records 100000 \
    --record-size 4096 \
    --producer-props bootstrap.servers=localhost:9092 \
    --throughput 100000 \
    --print-metrics
# ====== 1 Core & 4G RAM 測試結果 ======
8518 records sent, 1702.2 records/sec (6.65 MB/sec), 1120.9 ms avg latency, 1431.0 ms max latency.
15687 records sent, 3134.3 records/sec (12.24 MB/sec), 1093.2 ms avg latency, 1328.0 ms max latency.
17310 records sent, 3462.0 records/sec (13.52 MB/sec), 672.6 ms avg latency, 1109.0 ms max latency.
17053 records sent, 3410.6 records/sec (13.32 MB/sec), 74.8 ms avg latency, 342.0 ms max latency.
16567 records sent, 3313.4 records/sec (12.94 MB/sec), 25.9 ms avg latency, 103.0 ms max latency.
16817 records sent, 3352.7 records/sec (13.10 MB/sec), 23.3 ms avg latency, 139.0 ms max latency.
100000 records sent, 3099.141538 records/sec (12.11 MB/sec), 405.71 ms avg latency, 1431.00 ms max latency, 61 ms 50th, 1285 ms 95th, 1379 ms 99th, 1414 ms 99.9th.
# ====== 1 Core & 4G RAM 測試結果 ======
# --num-records     : 產生的 message 筆數
# --record-size     : message 大小 (bytes)
# --throughput      : 約束每秒鐘吞吐量的上限筆數. (不限制則設為 -1)
# --producer-props  : kafka 生產者相關配置屬性 (會覆蓋 --producer.config 配置)
#   --producer-props PROP-NAME=PROP-VALUE [PROP-NAME=PROP-VALUE ...]
# --producer.config : 可指定配置檔來運行


### 結束 kafka && 清除環境
$# rm -rf /tmp/kafka-logs /tmp/zookeeper
```


## Concept

- event / record / message. 由 `key + value + timestamp + optional metadata header` 組成
    - event 被組織到 topic 當中
    - Topic 為 資料夾 概念, event / record / message 則為 檔案 概念
- event 被消費以後, 並不會被刪除(可永久保留)
    - 可針對 topic 來配置保存期限
- topic 為 partitioned, 也就是說, topic 分布於 kafka brokers 之中的多個 buckets 當中
    > Topics are partitioned, meaning a topic is spread over a number of "buckets" located on different Kafka brokers.
    > Events with the same event key (e.g., a customer or vehicle ID) are written to the same partition, and Kafka guarantees that any consumer of a given topic-partition will always read that partition's events in exactly the same order as they were written.
- 把 Stream 想像成一種 unbounded, continuous real-time flow of records/facts
    - 如果談 Stream 時, 並不會把它稱做 message
    - 由 `KEY+VALUE` 組稱一組 `Data Record`, 連續的 `Data Record` (byte array)串流起來, 構成 Stream
    - 支援 stateless processing & stateful processing
- 一個 Partition 只能對應到一個 Consumer
    - 若 Partition Group 有 10 個 Consumer, 但只有分 8 個 Partition, 則會有 2 個 Consumer 沒事做
- 一個 Consumer 可以接收多個 Partition
- Kafka Streams 是個 Java library


## APIs

除了 management 及 administration 的 CLI 以外, 還有底下的 5 個 core APIs for Java 及 Scala:

- Admin API
    > The Admin API to manage and inspect topics, brokers, and other Kafka objects.
- Producer API
    > The Producer API to publish (write) a stream of events to one or more Kafka topics.
- Consumer API
    > The Consumer API to subscribe to (read) one or more topics and to process the stream of events produced to them.
- Streams API
    - streams api 與 kafka cluster 互動
    - stream processing work 在 APP 完成, 並不會在 broker 中執行
- Connect API


## Using Docker run kafka

```bash
$# docker network create -d bridge net_kfk

### zookeeper server instance(僅限開發用)
$# docker pull bitnami/zookeeper:3.7.0
$# docker run -d \
    --name zkp \
    --net net_kfk \
    -v $(pwd)/zoo.cfg:/conf/zoo.cfg \
    -e ALLOW_ANONYMOUS_LOGIN=yes \
    bitnami/zookeeper:3.7.0
# default EXPOSE 2181 2888 3888 8080


### 進入 zookeeper (比較特別一點...)
$# docker exec -it zkp zkCli.sh -server zkp
Connecting to zkp
Welcome to ZooKeeper!
JLine support is enabled

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
[zk: zkp(CONNECTED) 0]          # <--- 命令提示
# zookeeper command line 比較特殊, 分為 C 與 java
#   - java client 需使用 「zkCli.sh -server IP:port」

### kafka (僅限開發用)
$# docker pull bitnami/kafka:2.8.1
$# docker run -d \
    --name kafka \
    --net net_kfk \
    -e ALLOW_PLAINTEXT_LISTENER=yes \
    -p 9092:9092 \
    bitnami/kafka:latest

### Kafka - Server
$# docker run -d \
    --name kafka \
    --net net_kfk
    -e ALLOW_PLAINTEXT_LISTENER=yes \
    -e KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper-server:2181 \
    bitnami/kafka:latest

### Kafka - Client
$# docker run -it --rm \
    -e KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper-server:2181 \
    bitnami/kafka:latest kafka-topics.sh --list  --zookeeper zookeeper-server:2181
```

```yml
### docker-compose 資料持久化
  volumes:
    - /path/to/kafka-persistence:/bitnami/kafka
```
