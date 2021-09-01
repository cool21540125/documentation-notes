# [Enable Access Control](https://docs.mongodb.com/v4.4/tutorial/enable-authentication/)




----------------------------

底下為舊筆記

# MongoDB 權限機制
- 2018/05/21
- MongoDB v3.4、v3.6
- [Official - Enable Auth](https://docs.mongodb.com/v3.4/tutorial/enable-authentication/)
- [MongoDB user role設定筆記](https://www.facebook.com/notes/%E9%84%AD%E6%A5%AD%E8%96%B0/%E5%B7%A5%E4%BD%9C%E7%AD%86%E8%A8%98mongodb-user-role%E8%A8%AD%E5%AE%9A%E7%AD%86%E8%A8%98/10152402345234468/)
- [MongoDB建立資料庫使用者帳號](https://ithelp.ithome.com.tw/articles/10113778)
- [官方 Built-In Roles](https://docs.mongodb.com/v3.4/reference/built-in-roles/)

-------------------------------------

# [幫 MongoDB 搞權限](https://docs.mongodb.com/v3.4/tutorial/enable-authentication/#overview)

管理權限的 Database `admin`, 一開始需要在裡面創建一個使用者(名字應該隨便吧@@?), 要賦予 `userAdmin` or `userAdminAnyDatabase` 的權限. 如此一來, This user can administrate user and roles such as: create users, grant or revoke roles from users, and create or modify customs roles.


幾個讓我感覺非常哭腰的名詞
- users
- roles
- privileges
- resources
- actions
- databases


## Roles - 分為 2 類
1. User-Defined Role
2. [Built-In Roles](https://docs.mongodb.com/v3.4/reference/built-in-roles/)


## 相關語法備註

```js
// 首次建立 user
> db.createUser(
    { 
        user: "root", 
        pwd: "root_pd", 
        roles: [{ 
            role: "root", 
            db: "admin" 
        }]
    }
);
// return
Successfully added user: {
    "user" : "root",
    "roles" : [
        {
            "role" : "root",
            "db" : "admin"
        }
    ]
}
```

```js
// 查看 db 的 role
> db.runCommand({
    rolesInfo: {
        db: 'reporting', 
        role: 'readWrite'
    }
});
// return
{
    "roles" : [
        {
            "role" : "readWrite",
            "db" : "reporting",
            "isBuiltin" : true,
            "roles" : [ ],
            "inheritedRoles" : [ ]
        }
    ],
    "ok" : 1
}
```


```js
// 授權 role 給 user
> db.grantRolesToUser( "admin", [ 
    { 
        role: "readWrite", 
        db: "test_emc" 
    } 
]);



db.runCommand({
    rolesInfo: {
        db: 'test_emc', 
        role: 'admin'
    }
});

// 啥都沒回傳...
```


```js
// 建立 role
db.createRole(
    {
        role : "<Role Name>",
        privileges: [ {
                actions: [ 
                    "<Action1>", "<Action2>"
                ],
                resource: { 
                    db: "<Database Name>", 
                    collection: "<Collection Name>" 
                }
            }
        ],
        roles: []
    }
)


```



### mongodb權限管理

因mongodb預設安裝好後是沒有保護機制的，需自行建立登入機制保護資料

```js
use admin;
db.createUser({user:"root",pwd:"password123",roles:[{role:"root",db:"admin"}]});
// 這樣就有一個root帳號了!

// 接著創建專屬資料庫的帳號
use test;

// 擁有管理者權限
db.createUser({user:"admin",pwd:"password123",roles: [{ role: "readWrite", db: "test" }]});

// 擁有使用者權限
db.createUser({user:"user",pwd:"password123",roles: [{ role: "read", db: "test" }]});
// 登出 MongoDB

// 登入 MongoDB 再進 MongoDB 就要使用 帳號密碼 登入
mongod --auth --fork --dbpath ~/mongodb --logpath ~/log/mongodb.log
```


登入遇到

1. about to fork child process, waiting until server is ready for connections ERROR: child process failed, exited with error number 100 - 因為mongodb不正常關閉，刪除DBPATH裡的mongod.lock文件
2. ERROR:  child process failed ,exited with error number 1 - 增加DBPATH的寫入權限即可


```js
use admin;
db.auth("root", "password123");         // 以root登入
use test;
db.auth("admin", "password123");        // 以admin權限登入test資料庫(讀寫皆可)
db.auth("user", "password123");         // 以user權限登入test資料庫(只能讀)
```


### 遠端登入
1. 遠端連線
```sh
mongo --host <server ip> --port <server port>
```

2. 驗證
```js
> db.auth('<帳號>', '<密碼>');
// return
1
```



## [官方範例](https://docs.mongodb.com/v3.4/tutorial/enable-authentication/#procedure)

1. 建立 Mongo Daemon
```sh
# 這底下的資料夾盡量是空的, 玩壞了以後, 可以整個刪除XD
# 當然, 服務得先關掉
$ mongod --port 27017 --dbpath /tmp/qq --bind_ip 0.0.0.0
# 預設只有 localhost 能存取
```

2. 進入 mongodb
```sh
mongo --port 27017
```

3. 開始搞權限
```js
> use admin
> db.createUser({
    user: 'myUserAdmin',
    pwd: 'abc123',
    roles: [
        { role: 'userAdminAnyDatabase', db: 'admin' }
    ]
});
// 底下是回傳值... (不是指令)
Successfully added user: {
    "user" : "myUserAdmin",
    "roles" : [
        {
            "role" : "userAdminAnyDatabase",
            "db" : "admin"
        }
    ]
}
// 完成後離開 mongodb
// 這時候, 「/tmp/qq/」 裏頭, 會多出一大堆莫名其妙的東西
```

4. 再次使用權限進入
```sh
mongod --auth --port 27017 --dbpath /tmp/qq
```

5. 使用剛建立的 `myUserAdmin` User 登入
```sh
mongo --port 27017 -u "myUserAdmin" -p "abc123" --authenticationDatabase "admin"
```
或者, 使用 `mongo` 進入 MongoDB, 再進行權限驗證
```js
> db.auth({user: 'myUserAdmin', pwd: 'abc123'})
1       // 權限驗證成功
```

6. 建立其他的 user
```js
> use test
> db.createUser(
  {
    user: "myTester",
    pwd: "xyz123",
    roles: [ { role: "readWrite", db: "test" },
             { role: "read", db: "reporting" } ]
  }
)
// return 
Successfully added user: {
    "user" : "myTester",
    "roles" : [
        {
            "role" : "readWrite",
            "db" : "test"
        },
        {
            "role" : "read",
            "db" : "reporting"
        }
    ]
}
```

7. 使用剛建立的 `myTester` User 登入

```sh
mongo --port 27017 -u "myTester" -p "xyz123" --authenticationDatabase "test"
```
或者, 用 `mongo` 進入 MongoDB, 再進行權限驗證
```js
user test
db.auth("myTester", "xyz123")
```

[Manage Users and Roles](https://docs.mongodb.com/v3.4/tutorial/manage-users-and-roles/)
```js
> use admin
> db.createRole(
   {
     role: "manageOpRole",
     privileges: [
       { resource: { cluster: true }, actions: [ "killop", "inprog" ] },
       { resource: { db: "", collection: "" }, actions: [ "killCursors" ] }
     ],
     roles: []
   }
)
{
        "role" : "manageOpRole",
        "privileges" : [
                {
                        "resource" : {
                                "cluster" : true
                        },
                        "actions" : [
                                "killop",
                                "inprog"
                        ]
                },
                {
                        "resource" : {
                                "db" : "",
                                "collection" : ""
                        },
                        "actions" : [
                                "killCursors"
                        ]
                }
        ],
        "roles" : [ ]
}
```


# 以前弄的

```js
// 建立 帳號為 root 的使用者, 設定密碼, 對 admin 擁有 root (系統預設)的權限
use admin;
db.createUser({ user: "root", pwd: "root_pd", roles: [{ role: "root", db: "admin" }] });

// 建立 帳號為 root 的使用者, 設定密碼, 對 db2 擁有 dbOwner (系統預設)的權限
use db2;
db.createUser({ user: "admin", pwd: "admin_pwd", roles: [{ role: "dbOwner", db: "db2" }] });

db.createUser({ user: "admin", pwd: "1234%^&*", roles: [{ role: "dbOwner", db: "test_emc" }] });
```


```js
// 拔掉權限
db.runCommand({ revokeRolesFromUser: 'admin', roles: [ { role: 'readWrite', db: 'test_emc' } ]})
```

一旦建立完權限機制之後, 往後使用 mongoDB, 都得打帳號密碼了 QQ
```sh
# mongo <host>:<port>/<db> -u<id> -p<pd>
mongo 192.168.124.81:27017/admin -u root -p
# (下一行打密碼)
```

然後, 想為已建立過的使用者, 建立其他的權限
```sh
mongo -u root -p --authenticationDatabase admin

db.createUser({user: 'admin', pwd: 'admin_pwd', roles: [{ role: 'dbOwner', db: 'db2'}]})
```


# 其他
## 關於該死的 roles (還沒認真整理)
- userAdmin
- userAdminAnyDatabase 
    - 只能管控 users 和 roles, 無法作 collection 的 CRUD
- manageOpRole 
    - 只能作 2 件事情
        - db.currentOp()
        - db.killOp()
- mongostatRole
    - 只能作 `mongostat()`
- read
    - 唯讀
- readWrite
    - 讀寫權限
- clusterMonitor
    - 能作 `db.currentOp()`
- hostManager
    - 能作 `db.killOp()`

```
+ Database User Roles
    - read
    - readWrite

+ Database Admin Roles
    - dbOwner : 可對DB做任何事
    - userAdmin : 對 特定DB 安排 user, role/privilege
    - dbAdmin : 不具備 對於 非系統Collection 完整的read 權限

+ Cluster Admin Roles (Database: 'admin')
    - clusterAdmin
    - clusterManager
    - clusterMonitor
    - hostManager

+ BackupandRestoration Roles
    - backup
    - restore

+ All-DB Roles
    - readAnyDatabase : 在 admin 內設定. 可作 local、config DB以外的資料庫 唯讀
    - readWriteAnyDatabase : 在 admin 內設定. 可作 local、config DB以外的資料庫 讀寫
    - userAdminAnyDatabase : 當成 userAdmin 的概念來理解(對幾乎所有 DB)
    - dbAdminAnyDatabase : 當成 dbAdmin 的概念來理解(對幾乎所有 DB)

+ Superior-Roles
    - root : 擁有了 readWriteAnyDatabase , userAdminAnyDatabase , dbAdminAnyDatabase , clusterAdmin , restore , backup 的權限, 超級 op

+ Internal Roles
    - (讀不懂... 暫時不鳥它)
```

