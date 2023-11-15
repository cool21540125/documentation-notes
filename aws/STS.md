
# [AWS STS, Security Token Service](https://docs.aws.amazon.com/STS/latest/APIReference/welcome.html)

- AWS STS, AWS Security Token Service, 是個 Web Service
    - 可讓 users 取得 temporary, limited-privilege credentials

- STS 用來讓 Users 申請 Temporary Security Credential(temp creds) 及 limited-privilege creds
    - users 如下:
        - AWS Identity
        - IAM
        - for users you authenticate (federated users)
        - Contractor who don't have Iam User
    - temp creds, 有效期限大概落在 15~60 mins
- STS 是個 Web Service, global endpoint 為 : `https://sts.amazonaws.com`
    - 不過建議使用 Region endpoint 為主, 可參考底下 Url:
        - https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_enable-regions.html#id_credentials_temp_enable-regions_writing_code


# Terms

- IdP, Identity Provider 
- FIP, Federation Identity Provider
- 本文中上面兩者視為相同
- 底下的 **temporary security credentials**, 會統一縮寫成 **temp creds**


# STS actions

STS 支援了一系列的 actions, 可用來取得 **temp creds**


## AssumeRole

- 尻 AssumeRole Api 拿到的 **temp creds**, 裡頭包含了:
    - an access key pair:
        - access key ID
        - secret access key
    - a security Session Token
- 尻 AssumeRole Api 拿到的 **temp creds**, 可以做任何的 Api call, 但除了:
    - GetFederationToken
    - GetSessionToken
- Cross Account assume Role 的常見情境
    - 情境:
        - Account A 有個 User
        - Account B 有個 Role
        - User 想要 assume Role
    - 則需要:
        - Role 的 trust policy 有 Account A
        - Account A 需要 allow User 訪問 AssumeRole Api


## AssumeRoleWithSAML

- 尻 AssumeRoleWithSAML Api 拿到的 **temp creds**, 裡頭包含了:
    - an access key pair:
        - access key ID
        - secret access key
    - a security Session Token
- 尻 AssumeRoleWithSAML Api 拿到的 **temp creds**, 可以做任何的 Api call, 但除了:
    - GetFederationToken
    - GetSessionToken
- AssumeRoleWithSAML 可用來授予給 經由 SAML authentication 的 Users 使用. 內容包含
    - an access key ID
    - a secret access key
    - a security token
- 使用 AssumeRoleWithSAML 的時候, 不需要提供 AWS security credentials
- 使用 AssumeRoleWithSAML 的前置必要作業:


## AssumeRoleWithWebIdentity

- 使用 AssumeRoleWithWebIdentity 的時候, 不需要提供 security credentials
- 此 Api User, 會先從 Identity Provider 那邊驗證通過後拿到 **identity token**, 再來 AWS 這邊使用此 Api 來拿到 **temp creds**


## GetCallerIdentity

- 可用來取得呼叫此 Api 的 User/Role 的 credentials
    - 感覺有點類似 Linux 的 `whoami` 指令, 又或者是 `echo $0`
- 尻 GetCallerIdentity Api 拿到的 **temp creds**, 可以做任何的 Api call, 但除了:
    - AssumeRole 及 GetCallerIdentity 以外的 STS Api
    - any IAM Api operations (除非有提供 MFA authentication information)


## GetSessionToken

- 這 Api 我沒有花很多時間研究, 但研判 87% 應該與 MFA 有關
- 


# 雜記

(底下還非常亂, 沒整理)

- 用來給 *non AWS Users* 申請 *temp creds*
- user management outside of AWS
- 如果 Users 並非 AWS Users, 而是來自 *Identity Federation(身份聯盟)*, ex:
    - SAML 2.0
    - *SAML 2.0* 與 *Active Directory FS, ADFS* 有著非常高度的整合
        - 除了 AD 以外, 依舊有其他 directory services 可作選擇
            - 這些 AD 統稱 *SAML 2.0 Federation*
    - Custom Identity Broker
    - Web Identity Federation with Amazon Cognito
    - Web Identity Federation without Amazon Cognito
    - SSO, Single-Sign On
    - Non-SAML with AWs Microsoft AD
    - 可參考底下這些範例:
        - [SAML 2.0 Federation - Client APP](./iam.md#saml-20-federation---client-app)
        - [SAML 2.0 Federation - Browser](./iam.md#saml-20-federation---browser)
        - [SAML 2.0 Federation - ADFS, Active Directory FS](./iam.md#saml-20-federation---adfs-active-directory-fs)
- 要 AssumeRole 的一方, 藉由 `AssumeRoleWithSAML API` 來取得 *temp creds*
- 如果有多個 Account 需要逐一設定
- 藉由 SAML 來做 Federation 是老方法, AWS 推出了 [AWS SSO](./iam.md#aws-sso)
- DecodeAuthorizationMessage
- GetAccessKeyInfo
- GetFederationToken
    - MFA for users or AWS root Account
    - 如果 AWS users who use MFA && root Account, 使用此 API
