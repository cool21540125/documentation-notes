
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
    subgraph AWS
        direction LR
        up["CUP, Cognito User pool"]
        ip["CIP, Cognito Identity pool"]
        rr["AWS Resources"]
    end
    APP <-- 1. authentication && JWT token --> up;
    APP <-- 2. JWT token && creds --> ip;
    APP <-- 3. creds && resources --> rr
    ```


# CUP, Cognito User Pools

- Cognito User Pool 可與其他的 Federation Identity 整合

```mermaid
flowchart LR
    up["CUP, Cognito User pool"] -.- db["Serverless DB"]
    up -.- IdP;
    subgraph IdP["Federation through 3rd Identity Provider(IdP)"]
        Google; FB; SAML; OpenID
    end
```

---

- 較現代化的 **authentication flows** 包含了新的 challenge types(除了密碼驗證以外), AWS Cognito 的 authentication 需要實踐底下 API 的 [Authentication Flow](https://docs.aws.amazon.com/cognito/latest/developerguide/amazon-cognito-user-pools-authentication-flow.html):
    - InitiateAuth
    - RespondToAuthChallenge

```mermaid
flowchart LR

cup["Cognito User Pools"]
subgraph UserDevices
    direction LR
    m["Mobile"]
    w["WebApp"]
end

UserDevices -- "1. InitiateAuth (SRP)" --> cup;
cup -- "2. Challenge" --> UserDevices;
UserDevices -- "3. RespondToAuthChallenge" --> cup;
cup -- "4. Cognito Tokens" --> UserDevices;
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

cup["CUP, Cognito User Pools"]
api["API Gateway"]
APP <-- 1. auth & JWT Token --> cup;
APP <-- 2. JWT Token && REST API --> api;
cup <-- 3. Evaluate Token --> api;
api <-- 4. access --> backend;
```

```mermaid
flowchart LR

Client --> ALB;
ALB -- 1. authenticate --> cup["Cognito User Pools"]
ALB -- 2. access --> tg["Target Group"]
```


# CIP, Cognito Identity Pools

- Goal: 讓 client 直接訪問 AWS Resources (免 create IAM users)
    - ex: 要讓 FB user, 直接使用 S3
- 使用 **Cognito Identity Pool** 的話, 需要授權這服務使用 `AssumeRoleWithWebIdentity`
    - 如果不使用 Cognito, 而要讓 **external IdP** 訪問 AWS Resources (藉由 OIDC 或 SAML 2.0)的話, 則需要自行實作 `AssumeRoleWithWebIdentity` 這一段
        - 用來與 external IdP 取得 token, 去與 AWS 交換 `temporary security credentials`

```mermaid
flowchart TB

co["Cognito Federated Identity"]

subgraph extIdP["External IdP"]
    direction TB
    Google
    Apple
    FB
    SAML
    OpenID
end

APP["APP \n YOU"] -- 1. login --> extIdP
extIdP -- 2. token --> APP
APP -- 3. token --> co
co <-- 4. verify token --> extIdP
co <-- "5. temp creds\n(temporary AWS credentials)" --> STS
co -- 6. temp creds --> APP
APP -- 7. access --> aws["AWS Resources"]
```


# Cognito Sync

- 由 Cognito Service 與 Cognito Clients 構成
- 讓 User 可以跨裝置 同步 User data