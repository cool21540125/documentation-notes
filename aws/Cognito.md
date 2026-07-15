
# [Cognito](https://docs.aws.amazon.com/cognito/latest/developerguide/what-is-amazon-cognito.html)

- 用途:
    - 用來給 非 AWS Users identity
    - 用來做 APP / Web 的 認證 / 授權 / 用戶管理
- 主要元件如下(可分別 or 合併 使用)
    - Cognito User Pools, CUP
        - 用來給 APP Users 做 sign-up / sign-in
    - Cognito Identity Pools, CIP
        - 用來授權給 users 取得 **temp creds** 來 access AWS services
- 結合使用 User Pools 及 Identity Pools 的概念示意圖:
    ```mermaid
    flowchart LR
        APP["APP"]
        up["CUP<br/>Cognito User pool"]
        ip["CIP<br/>Cognito Identity pool"]
        rr["AWS Resources"]
        APP -->|1. auth & JWT| up
        APP -->|2. JWT & creds| ip
        ip -->|3. creds| rr
    ```


# CUP, Cognito User Pools

- Cognito User Pool 可與其他的 Federation Identity 整合

```mermaid
flowchart LR
    up["CUP<br/>Cognito User pool"]
    db["Serverless DB"]
    subgraph IdP["Federation through 3rd Identity Provider"]
        Google["Google"]
        FB["Facebook"]
        SAML["SAML"]
        OpenID["OpenID"]
    end
    up -.->|connect| db
    up -.->|integrate| IdP
```

---

- 較現代化的 **authentication flows** 包含了新的 challenge types(除了密碼驗證以外), AWS Cognito 的 authentication 需要實踐底下 API 的 [Authentication Flow](https://docs.aws.amazon.com/cognito/latest/developerguide/amazon-cognito-user-pools-authentication-flow.html):
    - InitiateAuth
    - RespondToAuthChallenge

```mermaid
flowchart LR
    cup["Cognito User Pools"]
    subgraph devices["User Devices"]
        mobile["Mobile"]
        webapp["WebApp"]
    end
    devices -->|1. InitiateAuth SRP| cup
    cup -->|2. Challenge| devices
    devices -->|3. RespondToAuthChallenge| cup
    cup -->|4. Cognito Tokens| devices
```

上圖的詳細時序如下

```mermaid
sequenceDiagram
    participant User
    participant Mobile or WebApp
    participant Cognito User Pool

    User->>Mobile or WebApp: Username and Password
    Mobile or WebApp->>Mobile or WebApp: SRP calculation
    Mobile or WebApp->>Cognito User Pool: InitiateAuth <br>USER_SPR_AUTH
    Cognito User Pool->>Mobile or WebApp: Challenge
    Mobile or WebApp->>User: Prompt
    User->>Mobile or WebApp: Response
    Mobile or WebApp->>Cognito User Pool: RespondToAuthChallenge
    Cognito User Pool->>Mobile or WebApp: AccessID, refresh Token
    Mobile or WebApp->>Mobile or WebApp: store Token
    Mobile or WebApp->>User: App content
```


- CUP 內建已整合了 API Gateway 以及 ALB

```mermaid
flowchart LR
    APP["APP"]
    cup["CUP<br/>Cognito User Pools"]
    api["API Gateway"]
    backend["Backend"]
    APP -->|1. auth & JWT| cup
    APP -->|2. JWT & REST API| api
    cup -->|3. Evaluate Token| api
    api -->|4. access| backend
```

```mermaid
flowchart LR
    client["Client"]
    alb["ALB"]
    cup["Cognito User Pools"]
    tg["Target Group"]
    client --> alb
    alb -->|1. authenticate| cup
    alb -->|2. access| tg
```


# CIP, Cognito Identity Pools

- Goal: 讓 client 直接訪問 AWS Resources (免 create IAM users)
    - ex: 要讓 FB user, 直接使用 S3
- 使用 **Cognito Identity Pool** 的話, 需要授權這服務使用 `AssumeRoleWithWebIdentity`
    - 如果不使用 Cognito, 而要讓 **external IdP** 訪問 AWS Resources (藉由 OIDC 或 SAML 2.0)的話, 則需要自行實作 `AssumeRoleWithWebIdentity` 這一段
        - 用來與 external IdP 取得 token, 去與 AWS 交換 `temporary security credentials`

```mermaid
flowchart TB
    app["APP<br/>YOU"]
    subgraph extIdP["External IdP"]
        google["Google"]
        apple["Apple"]
        fb["Facebook"]
        saml["SAML"]
        openid["OpenID"]
    end
    co["Cognito Federated<br/>Identity"]
    sts["STS"]
    aws["AWS Resources"]
    
    app -->|1. login| extIdP
    extIdP -->|2. token| app
    app -->|3. token| co
    co -->|4. verify token| extIdP
    co -->|5. temp creds| sts
    sts -->|temp credentials| co
    co -->|6. temp creds| app
    app -->|7. access| aws
```


# Cognito Sync

- 由 Cognito Service 與 Cognito Clients 構成
- 讓 User 可以跨裝置 同步 User data