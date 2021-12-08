# openssl 相關概念 && 指令

```bash
### 用來產生 token
$# openssl rand -hex 16


### 用來查看系統支援的 OpenSSL 加速引擎資訊
$# openssl engine -t
(rdrand) Intel RDRAND engine
     [ available ]
(dynamic) Dynamic engine loading support
     [ unavailable ]

### 
```

```bash
### 從 CSR 查看內容
$# openssl req -in ${DOMAIN}.csr -noout -text
Certificate Request:
    Data:
        Version: 0 (0x0)
        Subject: CN=hichat.info
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:b6:17:1e:69:b2:74:3b:ae:c3:29:32:de:dc:14:
                    fc:93:94:8d:c6:44:3e:ed:25:51:02:9b:ae:71:be:
                    98:db:46:fb:04:ae:56:eb:89:8d:b1:c8:43:84:5b:
                    8a:36:66:d9:54:fe:ed:50:b8:48:d4:4a:11:0a:7c:
                    9a:7c:1b:83:45:60:72:d2:31:52:62:2b:e7:a9:17:
                    28:df:49:ae:d6:d6:00:12:0f:5c:9d:00:80:06:ab:
                    b6:cc:b5:08:eb:5a:8a:2d:11:57:32:ce:86:59:38:
                    a7:c5:6d:5e:e6:f6:2a:5e:c4:bd:77:b2:6b:3f:46:
                    dd:78:b9:b9:ef:8b:7b:a9:a7:a7:23:4b:5d:72:c5:
                    a2:a6:a8:d0:b4:4b:8a:b0:01:9b:8d:af:bd:3a:d3:
                    a3:2e:bf:69:d9:a1:f6:d8:52:3a:a1:a1:d3:9f:df:
                    69:36:43:fd:31:ef:c6:36:1b:25:91:93:d6:8e:94:
                    c4:e3:5d:ab:f6:8b:83:49:6e:a9:48:7d:7b:4e:ac:
                    dc:e8:0f:69:39:aa:e2:2b:60:06:88:61:e1:ce:3d:
                    52:37:e3:64:96:07:4d:c2:07:f2:39:a4:47:35:07:
                    f1:81:a7:7e:cb:23:74:d4:8d:34:12:73:7c:3d:78:
                    f4:12:47:b0:ca:88:38:82:da:22:5d:4f:fc:f0:4a:
                    57:a1
                Exponent: 65537 (0x10001)
        Attributes:
        Requested Extensions:
            X509v3 Subject Alternative Name: 
                DNS:yohoohoo.info, DNS:yohoohoo.website, DNS:yohoohoo.space, DNS:yohoohoo.pro, DNS:yohoohoo.life, DNS:yohoohoo.online, DNS:yohoohoo.services, DNS:yohoohoo.net, DNS:yohoohoo.club, DNS:*.yohoohoo.info, DNS:*.yohoohoo.website, DNS:*.yohoohoo.space, DNS:*.yohoohoo.pro, DNS:*.yohoohoo.life, DNS:*.yohoohoo.online, DNS:*.yohoohoo.services, DNS:*.yohoohoo.net, DNS:*.yohoohoo.club  # 這邊可以看到多域名 CSR 的主體別名
    Signature Algorithm: sha256WithRSAEncryption
         28:fb:6e:35:b7:c7:ce:d3:22:e9:ce:0b:42:74:f7:06:c6:71:
         16:8a:58:ea:9b:1f:56:c2:8b:52:ef:7c:76:bb:cd:98:c0:0b:
         b3:da:7c:a6:27:dd:e9:e0:53:87:b9:a6:de:e4:bc:8d:c9:75:
         a1:43:c4:dc:55:8a:12:44:e2:48:33:f3:d2:43:b9:66:57:f9:
         b2:82:d3:65:c0:95:96:a0:ec:bd:10:03:33:ef:5a:b3:e0:cd:
         4b:58:65:bd:7f:22:c9:47:13:e5:c8:5b:93:e8:cb:d3:ff:56:
         96:29:c7:0b:c1:32:18:16:a3:6c:95:9b:72:b7:3c:75:05:10:
         7c:20:11:80:58:5a:2f:5d:b8:33:9d:ed:bc:0c:c5:04:38:5b:
         c8:3f:95:80:a9:29:70:60:95:5b:18:06:9d:50:de:57:33:a0:
         d6:55:1e:b7:7f:17:13:69:5b:a1:e4:96:bd:d5:00:47:1c:a0:
         a1:a2:1f:49:e4:60:7c:ab:0b:20:9a:24:0d:bb:fa:37:62:75:
         96:46:04:ef:4b:5d:9b:0b:bd:f7:6a:f5:bb:c0:74:2f:91:50:
         53:cb:af:54:63:15:54:d8:e2:52:83:ab:85:8e:39:69:f7:98:
         4c:3b:1b:e7:65:a1:a1:f8:82:11:28:cf:ca:45:45:c6:2a:17:
         b9:6e:05:4f

```