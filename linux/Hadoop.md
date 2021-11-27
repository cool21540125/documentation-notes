# Hadoop eco-system

- 2019/01/25


# Install Hadoop 相關

## 安裝 Hadoop 2.8

- [Hadoop載點們](http://ftp.mirror.tw/pub/apache/hadoop/common/)

```sh
$# wget http://ftp.mirror.tw/pub/apache/hadoop/common/hadoop-2.8.5/hadoop-2.8.5.tar.gz
$# tar -zxf hadoop-2.8.5.tar.gz
$#
```

## 安裝 HBase 2.0

安裝前, 必須設定
- hbase-site.xml
- hbase-env.sh
- regionservers

## 常用指令彙整

```sh

## ${HADOOP_HOME}/sbin/start-all.sh    # (Deprecated) 使用下 2 者代替
$# ${HADOOP_HOME}/sbin/start-dfs.sh    # 啟用 NameNode, DataNode, SecondaryNameNode
$# ${HADOOP_HOME}/sbin/start-yarn.sh   # 啟用 yarn, NodeManager, ResourceManager


## ${HADOOP_HOME}/sbin/start-all.sh    # (Deprecated) 使用下 2 者代替
$# ${HADOOP_HOME}/sbin/stop-yarn.sh    # 關閉 yarn, ResourceManager
$# ${HADOOP_HOME}/sbin/stop-dfs.sh     # 關閉 NameNode, DataNode, SecondaryNameNode

# hbase
$# ${HBASE_HOME}/bin/start-hbase.sh    # 啟用 HMaster
$# ${HBASE_HOME}/bin/stop-hbase.sh     # 關密 hbase

$# jps
```


## Version

```sh
$# hadoop version
Hadoop 2.8.5
Subversion https://git-wip-us.apache.org/repos/asf/hadoop.git -r 0b8464d75227fcee2c6e7f2410377b3d53d3d5f8
Compiled by jdu on 2018-09-10T03:32Z
Compiled with protoc 2.5.0
From source with checksum 9942ca5c745417c14e318835f420733
This command was run using /opt/hadoop/share/hadoop/common/hadoop-common-2.8.5.jar
```

## 啟用

```sh
### 啟用 hdfs
$# /opt/hadoop/sbin/start-dfs.sh        # 啟用 hdfs
$# /opt/hadoop/sbin/start-yarn.sh       # 啟用 yarn

```
