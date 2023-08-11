
- [Github-etcd](https://github.com/etcd-io/etcd)


# etcd

- 始於 2013/08, v0.1
- 官方首次穩定版 2015/02, v2.0
- 2017/01, v3.1
- 2018/12, 進入 CNCF 孵化階段


## 補充概念

- etcd 目前(2023/01)有 2 種版本, v2 & v3
    - `export ETCDCTL_API=3` 用來指定版本, 預設為 v2
- etcd 的 API Server 使用 certificate 來做 authentication
    - cert files 存放於 etcd-master
    - ```
      etcd ... 
        --cacert /etc/kubernetes/pki/etcd/ca.crt 
        --cert /etc/kubernetes/pki/etcd/server.crt 
        --key /etc/kubernetes/pki/etcd/server.key
      ```
