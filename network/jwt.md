jwt 組成, 由「.」分成 3 個部分的 Base64 編碼, ex: 「AA.BB.CC」

- Header : base64(Token type && hash(Signature))
- Payload/Claims : base64(Information(ex: User info))
- Signature : base64(hash(Header, Payload, Token))

Header:

```js
{
    "typ": "JWT",
    "alg": "AES256"
}
```

Payload

```js
{
    "_id": "",
    "name": "TonyChou",
    "age": 30,
    "exp": 2147483647  // Token 到期的時間
}
```

Signature

---

# JWT 架構

---

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
