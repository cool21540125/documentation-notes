
# AWS STS, Security Token Service

- [Welcome to the AWS Security Token Service API Reference](https://docs.aws.amazon.com/STS/latest/APIReference/welcome.html)
    - AWS Resources 的骨幹
- STS 用來申請 temp creds 及 limited-privilege creds 給底下這些用戶:
    - AWS Identity
    - IAM
    - for users you authenticate (federated users)
- 前面所說的 temp creds(Temperory Credentials), token 有效期限大概落在 15~60 mins
    - token 可能藏在 Request Header 的 cookie 或 URL 裏頭
    - IdP, Identity Provider (在本文中同 FIP)
    - FIP, Federation Identity Provider (在本文中同 IdP)


# STS actions

支援底下這一堆 actions


## AssumeRole

- AssumeRole 可用來取得 有權限訪問 AWS Resources 的 temp creds. 其取得的內容包含:
    - an access key ID
    - a secret access key
    - a security Token
- (AssumeRole 拿到的)temp creds 的使用例外(除了底下的 API 不能尻以外, 其他 AWS Resources 皆可使用):
    - GetFederationToken
    - GetSessionToken

(底下還非常亂, 沒整理)

帳號內, 定義一個 *IAM Role*, 來給 *AWS Users* && *Other AWS Users*
- 此 *IAM Role* 會限定 principals (也就是誰才可以用啦)



## AssumeRoleWithSAML

- AssumeRoleWithSAML 可用來授予給 經由 SAML authentication 的 Users 使用. 內容包含
    - an access key ID
    - a secret access key
    - a security token
- 此方法取得的 temp creds, 預設有效 3600 secs
- (AssumeRoleWithSAML 拿到的)temp creds 的使用例外:
    - GetFederationToken
    - GetSessionToken
- 使用 AssumeRoleWithSAML 的前置必要作業:
    > configure your SAML identity provider (IdP) to issue the claims required by AWS. 
    > 
    > Additionally, you must use AWS Identity and Access Management (IAM) to create a SAML provider entity in your AWS account that represents your identity provider. 
    > 
    > You must also create an IAM role that specifies this SAML provider in its trust policy.

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
- AssumeRoleWithWebIdentity
    - return creds for users logged in with an IdP(FB, Google, OIDC compatible...)
    - AWS 建議改為使用 **Cognito**
    - [Identity Federation](./iam.md#identity-federation)
- DecodeAuthorizationMessage
- GetAccessKeyInfo
- GetCallerIdentity
- GetFederationToken
- GetSessionToken
    - MFA for users or AWS root Account
    - 如果 AWS users who use MFA && root Account, 使用此 API
