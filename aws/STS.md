
# [AWS STS, Security Token Service](https://docs.aws.amazon.com/STS/latest/APIReference/welcome.html)

- AWS STS, AWS Security Token Service, 是個 Web Service
- STS 是個 Web Service, global endpoint 為 : `https://sts.amazonaws.com`
    - 不過建議使用 Region endpoint 為主, 可參考底下 Url:
        - https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_enable-regions.html#id_credentials_temp_enable-regions_writing_code
- STS 用來讓 Users 申請 Temporary Security Credential(temp creds) 及 limited-privilege creds
    - users 可能是下列之一:
        - AWS Identity
        - IAM
        - for users you authenticate (federated users)
        - Contractor who don't have Iam User
    - temp creds, 有效期限大概落在 15~60 mins


# Terms

- IdP, Identity Provider 
- FIP, Federation Identity Provider
- 本文中上面兩者視為相同
- 底下的 **temporary security credentials**, 會統一縮寫成 **temp creds**


# STS actions

STS 支援了一系列的 actions, 可用來取得 **temp creds**


## [AssumeRole](https://docs.aws.amazon.com/STS/latest/APIReference/API_AssumeRole.html)

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


## [AssumeRoleWithWebIdentity](https://docs.aws.amazon.com/STS/latest/APIReference/API_AssumeRoleWithWebIdentity.html)

- 使用 AssumeRoleWithWebIdentity 的時候, 不需要提供 security credentials
- 此 Api User, 會先從 Identity Provider 那邊驗證通過後拿到 **identity token**, 再來 AWS 這邊使用此 Api 來拿到 **temp creds**
- 拿到的 Response 包含:
    - AssumedRoleUser
    - Audience
    - Credentials
    - PackedPolicySize
    - Provider
    - SourceIdentity
    - SubjectFromWebIdentityToken


## GetCallerIdentity

- 可用來取得呼叫此 Api 的 User/Role 的 credentials
    - 感覺有點類似 Linux 的 `whoami` 指令, 又或者是 `echo $0`
- 尻 GetCallerIdentity Api 拿到的 **temp creds**, 基本上可以做任何的 Api call, 但除了:
    - AssumeRole 及 GetCallerIdentity 以外的 STS Api
    - any IAM Api operations (除非有提供 MFA authentication information)
- 拿到的 Response 包含:
    - Account : AWS Account ID number
    - Arn     : Account 的 Arn
    - UserId  : 就... UserID, ex: *ARO123EXAMPLE123*


## GetSessionToken

- The purpose of the sts:GetSessionToken operation is to authenticate the user using MFA
    - 如果 IAM User 啟用了 MFA, 則必須使用此 API
- 使用此 API 的話, 無需任何的 Permissions


# Temporary Credentials, temp creds

temp creds 很常出現在底下的情境:

- identity federation
- delegation
- cross account access
- IAM roles


## Identity federation

- AWS users 都不是由 AWS 管理, 而是在 external system
- 如果用 external system 是否為自行管理, 可在區分成下列 2 者:
    - Enterprise identity federation
        - 自家的 Data Center
        - 在自家 org 的 network 做身份認證, 此即為 single sign-on, SSO
        - AWS STS 支援了公開標準的 SAML 2.0
            - 可用像是 *Microsoft AD FS* to leverage *Microsoft Active Directory*
    - Web identity federation
        - web 上頭的 3rd
            - ex: Login with Amazon, Facebook, Google, or any OpenID Connect (OIDC) 2.0 compatible provider
        - 


## Delegation

## Cross Account access

## IAM roles



# 雜記

(底下還非常亂, 沒整理)

- AWS STS 用來給 *non AWS Users* 申請 *temp creds*
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
