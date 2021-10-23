
# MongoDB ReplicaSet

- 2021/03/03

### ReplicaSet 完成後再來執行

```js
rs.initiate({
    _id: "rs0",
    members: [
        { _id: 0, host: "mongodb01:27017" },
        { _id: 1, host: "mongodb02:27017" },
        { _id: 2, host: "mongodb03:27017" }
    ]
});
rs.status();

admin = db.getSiblingDB("admin");
admin.createUser(
    {
        user: "root",
        pwd: "1qaz@WSX",
        roles: [{ role: "root", db: "admin" }]
    }
);
admin.auth('root', '1qaz@WSX');

demo = db.getSiblingDB("demo_mongo");
demo.meta.insert({
    _id: '12345',
    accountName: 'tony',
    token: "123",
});
demo.createUser(
    {
        user: "tony",
        pwd: "5tgb^YHN",
        roles: [{
            role: "readWrite",
            db: "demo_mongo"
        }]
    }
);
demo.auth('tony', '5tgb^YHN');
```