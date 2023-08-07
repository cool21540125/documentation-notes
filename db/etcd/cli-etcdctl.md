

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
