# Role Attributes

- Postgres 的 database role 會有一系列的 attributes, 用來表彰它的 privileges 以及與 client authentication system 做互動

- login privilege
- superuser status
- database creation
- role creation
- initiating replication
- password
- connection limit

## PG 當中有各種不同的 privileges:

- https://www.postgresql.org/docs/current/ddl-priv.html

- 各種 privileges 及是否常用
  - [v] SELECT
  - [v] INSERT
  - [v] UPDATE
  - [v] DELETE
  - [ ] TRUNCATE
  - [v] REFERENCES
  - [ ] TRIGGER
  - [v] CREATE
  - [v] CONNECT
  - [v] TEMPORARY
  - [v] EXECUTE
  - [ ] USAGE
