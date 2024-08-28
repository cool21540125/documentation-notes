# PostgreSQL 相關組態

- [客戶端認證](https://www.postgresql.org/docs/11/client-authentication.html)

# Users and Roles

- PostgreSQL 的世界當中, User 及 Role 被視為是相同的東西 (User 其實是指向 Role 的別名)
  - Group 其實也是 Group of Roles (並非 Group of Users)
  - 更精確的說, `User = Role + Login Permission`
- 預設所有的 Users 及 Roles 都具備 `public` role

## pg_hba.conf

用戶端身分驗證檔

hba 表示 host-based authentication

## 密碼為基礎的認證

- https://www.postgresql.org/docs/11/auth-password.html

> There are several password-based authentication methods. These methods operate similarly but differ in how the users' passwords are stored on the server and how the password provided by a client is sent across the connection.
> 已密碼為基礎的認證方式有許多種, 差異在於 **Server 如何儲存密碼(如何被 encrypted(hashed))** && **Client 如發在連線過程發送密碼**

分成下面 3 種方式:

- scram-sha-256 : 被認為是比較安全的, 但對於比較舊版的 Client Library 並不支援...
- md5 : (預設) 但在許多年前, md5 早已被證實不再安全. 雖然他可抵禦 password sniffing && 明文儲存密碼, 但無法防止駭客竊取 `password hash`
- password : 明文傳送密碼(如果連線本身已經加密, 則可使用) (但既然已經加密了, 建議乾脆直接使用 SSL 證書認證)

以上的密碼加密方式, 定義在 `$PGDATA/postgresql.conf` 的 `#password_encryption = md5`. 需連同 `$PGDATA/pg_hba.conf` 一起修改
