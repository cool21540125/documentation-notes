
- 2023/08/05
- [Provisioning a CA and Generating TLS Certificates](https://github.com/mmumshad/kubernetes-the-hard-way/blob/master/docs/04-certificate-authority.md)

```bash
lsb_release -a
#No LSB modules are available.
#Distributor ID: Ubuntu
#Description:    Ubuntu 22.04.3 LTS
#Release:        22.04
#Codename:       jammy


### Example from Ubuntu22.04
openssl version
#OpenSSL 3.0.2 15 Mar 2022 (Library: OpenSSL 3.0.2 15 Mar 2022)
```


# 自建 CA Server

```bash
### CA Server, 產生 CA private key
openssl genrsa -out ca.key 4096
# CA Server 需要使用的 Private Key : ca.key


### 使用 CA 的 Private Key 生成 CSR
openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr
# CA Server 生成 CSR : ca.csr


### 自簽 
openssl x509 -req -in ca.csr -signkey ca.key -CAcreateserial -out ca.crt -days 3650
#Certificate request self-signature ok
#subject=CN = KUBERNETES-CA
```


### 建立 Admin Certificate

```bash
### 生成 Admin Private Key
openssl genrsa -out admin.key 2048


### Admin Site 使用 Private Key 製作 CSR
openssl req -new -key admin.key -subj "/CN=admin/O=system:masters" -out admin.csr



### 將 CSR 拿給 CA 簽署
openssl x509 -req -in admin.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out admin.crt -days 365
#Certificate request self-signature ok
#subject=CN = admin, O = system:masters
```
