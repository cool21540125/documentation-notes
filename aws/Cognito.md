
# Cognito

- [What is Amazon Cognito?](https://docs.aws.amazon.com/cognito/latest/developerguide/what-is-amazon-cognito.html)
    - 用來給 非 AWS Users identity
    - 用來做 APP 的 認證 / 授權 / 用戶管理
- 主要元件如下(可分別 or 合併 使用)
    - Cognito User Pools
        - 用來給 APP Users 做 sign-up / sign-in
    - Cognito Identity Pools
        - 用來授權給 users 來 access AWS services
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


## CUP, Cognito User Pools

- Cognito User Pool 可與其他的 Federation Identity 整合
    ```mermaid
    flowchart LR
        up["CUP, Cognito User pool"] -.- db["Serverless DB"]
        up -.- IdP;
        subgraph IdP["Federation through 3rd Identity Provider(IdP)"]
            Google; FB; SAML; OpenID
        end
    ```
- 較現代化的 **authentication flows** 包含了新的 challenge types(除了密碼驗證以外), AWS Cognito 的 authentication 需要實踐底下 API 的驗證流程:
    - InitiateAuth
    - RespondToAuthChallenge
    ```mermaid
    flowchart LR

    cup["Cognito User Pools"]
    subgraph c
        direction LR
        m["mobile client"]
        w["web client"]
    end

    c -- "1. InitiateAuth (SRP)" --> cup;
    cup -- "2. Challenge" --> c;
    c -- "3. RespondToAuthChallenge" --> cup;
    cup -- "4. Cognito Tokens" --> c;
    ```
    - https://docs.aws.amazon.com/cognito/latest/developerguide/amazon-cognito-user-pools-authentication-flow.html
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


#