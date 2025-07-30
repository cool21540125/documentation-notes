#!/bin/bash
exit 0
# ------------------------------------------------------------------------------------------------
# Provisioning a CA and Generating TLS Certificates
#   https://github.com/mmumshad/kubernetes-the-hard-way/blob/master/docs/04-certificate-authority.md

lsb_release -a
#No LSB modules are available.
#Distributor ID: Ubuntu
#Description:    Ubuntu 24.04.2 LTS
#Release:        24.04
#Codename:       noble

openssl version
#OpenSSL 3.0.13 30 Jan 2024 (Library: OpenSSL 3.0.13 30 Jan 2024)

### =================== 自建 CA Server ===================

### CA Server, 產生 CA private key
openssl genrsa -out ca.key 4096
# 生成: ca.key

### privateKey 生成 PublicKey
openssl rsa -in ca.key -pubout -out ca.pub
openssl rsa -in ca.key -pubout >ca.pub

### privateKey 生成 CSR
openssl req -new -key ca.key -subj "/CN=EC2_STG_CA" -out ca.csr
openssl req -new -key ca.key -subj "/CN=EC2_STG_CA" >ca.csr

### 自簽
openssl x509 -req -in ca.csr -signkey ca.key -CAcreateserial -out ca.crt -days 3650
#生成 ca.crt (ca.key 及 ca.csr 簽發)

### =================== 建立 Admin Certificate ===================
### 生成 Admin Private Key
openssl genrsa -out admin.key 4096

### Admin Site 使用 Private Key 製作 CSR
openssl req -new -key admin.key -subj "/CN=admin/O=system:masters" -out admin.csr

### 將 CSR 拿給 CA 簽署
openssl x509 -req -in admin.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out admin.crt -days 3650
#Certificate request self-signature ok
#subject=CN = admin, O = system:masters

### 從查看 crt 資訊
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout

###