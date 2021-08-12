[Role Management Methods](https://docs.mongodb.com/v4.4/reference/method/db.getRoles/)

```bash
# (登入 mongoDB 的 admin DB以後)
### 在 admin DB, 建立 Role, 允許對任何 Resource 做任何 action, roleName 為 pbmAnyAction
> db.getSiblingDB("admin").createRole(
{ "role": "pbmAnyAction",
    "privileges": [
        { "resource": { "anyResource": true },
            "actions": [ "anyAction" ]
        }
    ],
    "roles": []
});

### 取得所有的 Roles
> db.getRoles()
[
	{
		"role" : "pbmAnyAction",
		"db" : "admin",
		"isBuiltin" : false,
		"roles" : [ ],
		"inheritedRoles" : [ ]
	}
]

### 取得單一 Role 資訊
> db.getRole("pbmAnyAction")
{
	"role" : "pbmAnyAction",
	"db" : "admin",
	"isBuiltin" : false,
	"roles" : [ ],
	"inheritedRoles" : [ ]
}
```