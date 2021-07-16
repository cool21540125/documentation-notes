[Client List](https://redis.io/commands/client-list)

> 2.4.0+

> `client list [TYPE normal|master|replica|pubsub]`
```bash
$# redis-cli -c client list
id=4 addr=172.16.30.13:42061 fd=17 name= age=126690 idle=0 flags=S db=0 sub=0 psub=0 multi=-1 qbuf=0 qbuf-free=0 argv-mem=0 obl=0 oll=0 omem=0 tot-mem=20512 events=r cmd=replconf user=default
id=12 addr=172.16.30.8:41692 fd=21 name= age=25373 idle=22708 flags=N db=0 sub=0 psub=0 multi=-1 qbuf=0 qbuf-free=0 argv-mem=0 obl=0 oll=0 omem=0 tot-mem=20504 events=r cmd=del user=default
id=14 addr=172.16.30.9:53376 fd=22 name= age=25283 idle=25283 flags=N db=0 sub=0 psub=0 multi=-1 qbuf=0 qbuf-free=0 argv-mem=0 obl=0 oll=0 omem=0 tot-mem=20512 events=r cmd=set user=default
id=53 addr=127.0.0.1:47476 fd=23 name= age=0 idle=0 flags=N db=0 sub=0 psub=0 multi=-1 qbuf=26 qbuf-free=32742 argv-mem=10 obl=0 oll=0 omem=0 tot-mem=61466 events=r cmd=client user=default
# addr: Redis Client 的 host:port
# age: 此連線的 total duration (秒)
# idle: 此連線的 idle time (秒)
# qbuf: query buffer length (0 表示 「無 pending」 的查詢)
# qbuf-free: free space of the query buffer (0 表示 buffer 已滿)
# cmd: 最近一次執行的動作
```






