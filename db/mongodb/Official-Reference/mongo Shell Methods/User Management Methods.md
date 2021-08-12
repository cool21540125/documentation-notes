[User Management Methods](https://docs.mongodb.com/v4.4/reference/method/js-user-management/)

User 的概念是, 每個 Database 有自己的 User. 
    - root User 僅存在於 admin DB

```bash
### 顯示 DB 裡面所有用戶資訊
> db.getSiblingDB("admin").getUsers();
[
	{
		"_id" : "admin.root",
		"userId" : UUID("9d7b3537-32ce-44f3-9522-afe71b92eegp"),
		"user" : "root",
		"db" : "admin",
		"roles" : [
			{
				"role" : "root",
				"db" : "admin"
			}
		],
		"mechanisms" : [
			"SCRAM-SHA-1",
			"SCRAM-SHA-256"
		]
	}
]

### 建立 User && 並同時賦予 pbmAnyAction Role
> db.getSiblingDB("admin").createRole(
{ 
    "role": "pbmAnyAction",
    "privileges": [
        { 
            "resource": { "anyResource": true },
            "actions": [ "anyAction" ]
        }
    ],
    "roles": []
});
```