# JWT 架構

- https://jwt.io/
- jwt 組成, 由「.」分成 3 個部分的 Base64 編碼, ex: 「AA.BB.CC」
  - Header : base64(Token type && hash(Signature))
  - alg : 預設是 HMAC SHA256, HS256 ?
  - type : 為 Token 類型
  - Payload/Claims : base64(Information(ex: User info))
    - Decoded Payload 的欄位:
      - sub : 這就是
  - Signature : base64(hash(Header, Payload, Token))

## Externally resolved tenant context

```mermaid
flowchart

svc("Product microservice")
tenant("Tenant microservice
user --> tenant")

t1[("tenant1")]
t2[("tenant2")]

svc <-- "Lookup tenant" --> tenant
svc --> t1
svc --> t2
```

---

## JWT with embedded tenant context

```mermaid
flowchart

somewhere(" ")
t1[("tenant1")]
t2[("tenant2")]

subgraph x["Product microservice"]
    token("Token manager")
end

t1[("tenant1")]
t2[("tenant2")]

somewhere -- "JWT token" --> x

x --> t1
x --> t2

```

---
