#!/bin/bash
exit 0
# ------------------------------------------------------------------------------------------------------------------------------------------------

### Version
etcdctl version
#etcdctl version: 3.6.0-rc.3
#API version: 3.6

### ============================ 列出 tls-enabled 的 etcd-cluster ============================
etcdctl --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/etcd/ca.crt \
  --cert=/etc/etcd/etcd.crt \
  --key=/etc/etcd/etcd.key \
  member list

### restore
etcdctl --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/etcd/ca.crt \
  --cert=/etc/etcd/etcd.crt \
  --key=/etc/etcd/etcd.key \
  --data-dir=/var/lib/etcd-from-backup \
  snapshot restore /opt/snapshot-pre-boot.db

# --data-dir=/var/lib/etcd-from-backup
#  聲明 restore 到其他 dir, 是為了避免蓋掉目前的狀態

# backup etcd & restore

#- etcd 的 backup 有底下 2 種方式:
#    - etcd built-in snapshot
#        - 參考指令: `ETCDCTL_API=3 etcdctl --endpoints $ENDPOINT snapshot save snapshot.db`
#    - volume snapshot
#        - 直接從 Storage 做備份

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

# Simple Usage

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
