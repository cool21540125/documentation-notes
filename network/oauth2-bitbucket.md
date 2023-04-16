
- 這個是查看 Bitbucket Oauth 支援的一些雜記 (沒有任何重點及心得...)
- 2023/04/16


# [Use OAuth on Bitbucket Cloud](https://support.atlassian.com/bitbucket-cloud/docs/use-oauth-on-bitbucket-cloud/)

- 在 Bitbucket 裏頭, 先去申請一個 `OAuth Consumer`
    - https://bitbucket.org/{workspace}/workspace/settings/api, ex: https://bitbucket.org/tonychoucc/workspace/settings/api
    - 會得到一個 `key` 及 `secret` (這就代表了一個 OAuth Consumer)
    - 可以用 `OAuth Consumer` 來 exchange `JWT token` for `access token`
- Bitbucket 提供了 3 種 RFC-6749 + Bitbucket flow, 用來做 exchange `JWT token` for `access token`


#### Authorization code grant

- Request authorization from the end user by sending their browser to:
- https://bitbucket.org/site/oauth2/authorize?client_id={client_id}&response_type=code
- (不懂上面說的)


#### Implicit grant

- 適用於 browser-based operation (無 backend support)
- Implicit grant type 會向 user 請求授權 && 將 browser redirect 到底下 URL:
- https://bitbucket.org/site/oauth2/authorize?client_id={key}&response_type=token


# Making requests

拿到 `access token` 以後, 即可用下列方式來發送請求~

- 直接夾帶在 Request Header : `Authorization: Bearer {access_token}`
- Request Header 需聲明 2 部分: `application/x-www-form-urlencoded` 及 `access_token={access_token}`
- 使用 non-POST 放在 Query String: `?access_token={access_token}`

`access token` 到期的話, 會拿到 401. 可使用下列方式來 refresh token

```http
curl -X POST -u "client_id:secret"
  https://bitbucket.org/site/oauth2/access_token \
  -d grant_type=refresh_token -d refresh_token={refresh_token}
```
