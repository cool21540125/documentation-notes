# Install postgresql by docker

- 2020/04/06
- [DockerHub-postgrs](https://hub.docker.com/_/postgres)


```bash
### 2020/04/06 latest 為 12, 但聽說不穩定?...
$# docker pull postgresql:11

$# PASSWD=1234
$# docker volume create pg_data
$# docker run -d \
    -v pg_data:/var/lib/postgresql/data \
    -p 5432:5432 \
    -e POSTGRES_PASSWORD=${PASSWD} \
    --name=mypg \
    postgres:11
```


## 備註

- Container 執行之後, 預設會執行 `/docker-entrypoint-initdb.d/` 內的: `*.sql`, `*.sql.gz`, `*.sh`
- pg 11 的 Container, 設定主檔在: `/var/lib/postgresql/postgresql.conf`, 資料也都在裡面
- 查詢 `echo ${PGDATA}` 可看檔案都放哪邊
- SSL
  - ssl_cert_file
  - ssl_key_file
  - ssl_ca_file
  - ssl_crl_file


```bash
$# openssl req -new -x509 -days 365 -nodes -text -out root.crt \
  -keyout root.key -subj "/CN=vm-42"
# 產生 root.crt, root.key

$# chmod og-rwx root.key
# 私鑰 600

$# openssl req -new -nodes -text -out server.csr \
  -keyout server.key -subj "/CN=vm-42"
# 產生 server.csr, server.key
$# chmod og-rwx server.key
# 600

$# openssl x509 -req -in server.csr -text -days 3650 \
  -extfile /etc/pki/tls/openssl.cnf -extensions v3_ca \
  -signkey server.key -out server.crt
# 產生 server.crt

$# openssl req -new -nodes -text -out root.csr \
  -keyout root.key -subj "/CN=vm-42"
# 產生 root.csr
$# chmod og-rwx root.key
# 600

$# openssl x509 -req -in root.csr -text -days 365 \
  -CA server.crt -CAkey server.key -CAcreateserial \
  -out root.crt
# 簽署
# 產生 server.srl
```