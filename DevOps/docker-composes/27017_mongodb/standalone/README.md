# MongoDB

- https://hub.docker.com/_/mongo
- 2021/03/03, latest is 4.4.4


```bash
DB=demo
USER=root
mongo --username ${USER} --password
```

```js
show databases;
db.getName();
db.getUsers();
```