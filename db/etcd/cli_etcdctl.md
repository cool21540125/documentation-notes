

# etcdctl admin

```bash
### Version
./etcd --version
#etcd Version: 3.4.27


### Run Server
./etcd
# run on localhost:2379


### 
./etcd --name $ETCD_NAME --data-dir=/var/lib/etcd
```


# etcd tls

- 如果 ETCD database 已經啟用了 TLS-Enabled, 訪問時需加上底下參數, ex:

```bash
### backup
etcdctl --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  snapshot save /opt/snapshot-pre-boot.db

### restore
etcdctl --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  --data-dir=/var/lib/etcd-from-backup \
  snapshot restore /opt/snapshot-pre-boot.db

# --data-dir=/var/lib/etcd-from-backup 
#  聲明 restore 到其他 dir, 是為了避免蓋掉目前的狀態
```


# backup etcd & restore

- etcd 的 backup 有底下 2 種方式:
    - etcd built-in snapshot
        - 參考指令: `ETCDCTL_API=3 etcdctl --endpoints $ENDPOINT snapshot save snapshot.db`
    - volume snapshot
        - 直接從 Storage 做備份

```bash
###### ====== 這邊的指令當作參考就好, 應該無法被完整執行 ======

export ETCDCTL_API=3


etcdctl snapshot save -h
etcdctl snapshot restore -h


### backup etcd
etcdctl snapshot save snapshot.db
# 生成 snapshot.db


### 查看 backup
etcdctl snapshot status snapshot.db


### 要做 restore 以前, 必須先停止 apiserver (我對這有點疑慮)
systemctl stop kube-apiserver


### 由 backup 做 etcd restore
etcdctl snapshot restore snapshot.db --data-dir /path/to/new/dir/that/want/etcd/to/use
# 會建立新的 Dir, 並且 initialize new cluster configuration

# 後續再去修改 etcd.service
# 將 --data-dir 指向到上面指定的 --data-dir
systemctl daemon-reload
systemctl start kube-apiserver
```


# Simple Usage

```bash
### set value
./etcdctl put name tony
#OK


### get value
./etcdctl get name
#name
#tony


### 查詢 k8s 存放於 etcd 的 keys
./etcdctl get "" --prefix --keys-only
#name


### 
```
