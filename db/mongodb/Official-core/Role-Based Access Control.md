[Role-Based Access Control](https://docs.mongodb.com/v4.4/core/authorization/)

- MongoDB 使用 **Role-Based Access Control, RBAC, (role-based authorization)** 來管理權限
    - 特定 User 可以被賦予多個 roles 來存取特定 Database Resources 以及作對應操作
    - 反過來說, 如果沒有對應的 role, 則無法做任何事情
- 預設, MongoDB 沒有啟用 Access Control. 如果一旦有任何用戶啟用了權限控管, 則 mongod 便開始受 RBAC 的約束
- Roles
    - A role grants privileges to perform the specified actions on resource.
    - privilege 與 action 的說明, 參考 [Privilege Actions](https://docs.mongodb.com/v4.4/reference/privilege-actions/)
- 特定 DB 裡面建立的第一個 User, 必須為 administrator

```js
> use admin;
> db.system.roles.find().pretty();
{
	"_id" : "admin.pbmAnyAction",
	"role" : "pbmAnyAction",
	"db" : "admin",
	"privileges" : [
		{
			"resource" : {
				"anyResource" : true
			},
			"actions" : [
				"anyAction"
			]
		}
	],
	"roles" : [ ]
}

// 查看 DB 裏頭所有的 roles
> db.getRoles();
[
	{
		"role" : "pbmAnyAction",
		"db" : "admin",
		"isBuiltin" : false,
		"roles" : [ ],
		"inheritedRoles" : [ ]
	}
]

> db.getRoles({ showPrivileges: true });
[
	{
		"role" : "pbmAnyAction",
		"db" : "admin",
		"isBuiltin" : false,
		"roles" : [ ],
		"inheritedRoles" : [ ],
		"privileges" : [
			{
				"resource" : {
					"anyResource" : true
				},
				"actions" : [
					"anyAction"
				]
			}
		],
		"inheritedPrivileges" : [
			{
				"resource" : {
					"anyResource" : true
				},
				"actions" : [
					"anyAction"
				]
			}
		]
	}
]
```


MongoDB 提供了一系列定義好的 *Built-In Roles*, 也提供了 built-in `database user` && `database administration role`