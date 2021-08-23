
- [Pbm backup error in a replicaset non-sharded scenario](https://forums.percona.com/t/pbm-backup-error-in-a-replicaset-non-sharded-scenario/11709)


## ReplicaSet Cluster backup 初始配置

```js
// 進入 Mongo Shell 建立 Backup 所需 User & Priv
db.getSiblingDB("admin").createRole({
    "role": "pbmAnyAction",
    "privileges": [
        { "resource": { "anyResource": true },
        "actions": [ "anyAction" ]
        }
    ],
    "roles": []
});

db.getSiblingDB("admin").createUser({
    "user": "pbmuser",
    "pwd": "secretpwd",
    "roles" : [
        { "db" : "admin", "role" : "readWrite", "collection": "" },
        { "db" : "admin", "role" : "backup" },
        { "db" : "admin", "role" : "clusterMonitor" },
        { "db" : "admin", "role" : "restore" },
        { "db" : "admin", "role" : "pbmAnyAction" }
    ]
});
// 帳號可一樣維持 pbmuser, 密碼 'secretpwd' 記得調整~

db.getSiblingDB("admin").system.users.find({'user': 'pbmuser'}).pretty();
db.getSiblingDB("admin").system.roles.find({'role': 'pbmAnyAction'}).pretty();
// ↑ 每個 ReplicaSet members 都要有這個 user & role
// 但基本上, 如果是 Non-sharded Cluster, 直接再 Primary 上面新增 User & Role 就可以了
```


```bash
$# which pbm-agent pbm
/bin/pbm-agent
/bin/pbm


### 配置遠端備份儲存位置
# 法一: 使用 s3 Backup
cat <<"EOT" > /etc/pbm-storage-s3.yaml
storage:
  type: s3
  s3:
    region: ap-northeast-2
    bucket: BUCKET_NAME
    prefix: DIR_NAME
    credentials:
      access-key-id: AWS_KEY_ID
      secret-access-key: AWS_SECRET
EOT
# 法二: 使用 local Backup
cat <<"EOT" > /etc/pbm-storage-local.yaml
storage:
  type: filesystem
  filesystem:
    path: /data/local_backups
EOT

chmod 600  /etc/pbm-storage-*.yaml
chown pbm. /etc/pbm-storage-*.yaml


### 法1. 使用 pbm CLI 以前, export PBM_MONGODB_URI 可免除還要輸入 「--mongodb-uri=XXXX」 的繁瑣參數
export PBM_MONGODB_URI="mongodb://pbmuser:secretpwd@localhost:27017/?replSetName=rs0?authSource=admin"

pbm config --file /etc/pbm-storage-local.yaml \
    --mongodb-uri ${PBM_MONGODB_URI}

### 法2. 使用永久設定方式, 寫入到 /etc/sysconfig/pbm-agent
tee /etc/sysconfig/pbm-agent <<EOF
PBM_MONGODB_URI="mongodb://pbmuser:secretpwd@localhost:27017/?replSetName=rs0?authSource=admin"
EOF

pbm config --file /etc/pbm-storage-local.yaml
# 法2 好像沒辦法這麼理想, 似乎還是得帶 --mongodb-uri

### 執行備份~~
pbm backup
# 300M 左右的 DB, 大概做了 10 來秒. 弄出來的檔案大小卻只有 10 KB 左右, 覺得害怕
```


### pbm config 操作

```bash
### 配置檔的設定與查看
$# pbm config --file /PATH/TO/pbm_conf.yml
[Config set]
------
pitr:
  enabled: false
storage:
  type: s3
  s3:
    provider: aws
    region: XXXX
    bucket: QQQQQ
    prefix: WWWWW
    credentials:
      access-key-id: '***'
      secret-access-key: '***'

Backup list resync from the store has started
# 設定完後, 可看到上面的輸出結果

$# pbm config storage.type
s3

$# pbm config storage.s3.prefix
"WWWWW"

### 也可用 CLI 來修改單一值
$# pbm config --set storage.s3.prefix=GGGGG
[storage.s3.prefix=GGGGG]
Backup list resync from the store has started
# ↑ 但是這個操作不會改寫檔案. 此配置僅在 RAM 裡面做操作

$# pbm config storage.s3.prefix
"GGGGG"

### 列出目前記憶體的配置
$# pbm config --list
pitr:
  enabled: false
storage:
  type: s3
  s3:
    provider: aws
    region: XXXX
    bucket: QQQQQ
    prefix: GGGGG
    credentials:
      access-key-id: '***'
      secret-access-key: '***'
```


### pbm list

```bash
### 查看目前配置
$# export PBM_MONGODB_URI="mongodb://pbmuser:secretpwd@localhost:27017/?replSetName=rs0?authSource=admin"
$# pbm list
Backup snapshots:
  2021-08-19T09:50:51Z [complete: 2021-08-19T09:51:13]
```
