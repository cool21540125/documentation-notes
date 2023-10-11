
# Open Authorization, OAuth

- OAuth 是個允許 end user account info 被其他 3rd 使用, 並且不用洩漏其密碼
    - ex: 


# Single Sign-On - SSO

- SSO 是個 `session and user authentication service`
    - 讓 user 藉由一組 **login credentials** 來訪問多個 Applications
        - 例如, 帳號密碼
- SSO 是個 `federated identity management (聯合身份識別管理)` arrangement
    - SSO 這類系統的使用, 有時被稱作 `Identity Federation`
- 自己的理解
    - When a user attempts to access an application from the service provider, the service provider sends a request to the identity provider for authentication. The service provider then verifies the authentication and logs the user in.
    - 使用者登入 Service Provider(Steam) 以後, 想要使用 Application(世紀帝國2), Steam 會發送認證請求給背後的 Identity Provider(也是 Steam 的認證服務)
    - 認證通過以後, Steam 會收到一組 被允許使用 世紀帝國2 的 token, 後續便可遊玩 世紀帝國2
