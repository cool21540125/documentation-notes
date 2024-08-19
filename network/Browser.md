# Browser 發送請求

```mermaid
sequenceDiagram
    Browser ->>+ DNS: 域名解析
    DNS ->>- Browser: IP

    Browser ->>+ Server: 3 way handshake
    Server ->>- Browser: 完成 TLS/SSL 交握

    Browser ->> Browser: 建構 HTTP Request 充填 Context 到 Header

    Browser ->>+ Server: Http Request
    Server ->>- Browser: Http Response

    Browser ->> Browser: Render
```