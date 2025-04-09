#!/bin/bash
exit 0
# ---------------------------------------------------------------------------------------------------------------------------------

COGNITO_CLIENT_ID=
UserName=cool21540125@gmail.com
PASSWORD=

#
### =================== 註冊一個 Cognito User ===================
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/confirm-sign-up.html#examples

## 註冊 Useer
aws cognito-idp sign-up --client-id $COGNITO_CLIENT_ID --username cool21540125@gmail.com --password $PASSWORD --user-attributes Name="email",Value="cool21540125@gmail.com" Name="name",Value="tony"
# (上面) Cognito Client App 沒使用 client secret
# (下面) Cognito Client App 有使用 client secret
APP_CLIENT_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx # Cognito App Client 建立完成後隨機產生 (到頁面去看吧)
HASHED_SECRET=$(echo -n "cool21540125@gmail.com$COGNITO_CLIENT_ID" | openssl dgst -sha256 -hmac $APP_CLIENT_SECRET -binary | openssl enc -base64)
aws cognito-idp sign-up --client-id $COGNITO_CLIENT_ID --username cool21540125@gmail.com --password $PASSWORD --secret-hash "$HASHED_SECRET" --user-attributes Name="email",Value="cool21540125@gmail.com" Name="name",Value="tony"

# 註冊完以後去收信

## 確認註冊 (填驗證碼)
VERIFICATION_CODE=000000
aws cognito-idp confirm-sign-up --client-id $COGNITO_CLIENT_ID --username=cool21540125@gmail.com --confirmation-code $VERIFICATION_CODE
# (上面) Cognito Client App 沒使用 client secret
# (下面) Cognito Client App 有使用 client secret
aws cognito-idp confirm-sign-up --client-id $COGNITO_CLIENT_ID --username=cool21540125@gmail.com --secret-hash "$HASHED_SECRET" --confirmation-code $VERIFICATION_CODE
# 成功的話, 不會有 response (只能從 Web Console 上頭確認 ~"~")

#
### =================== Login ===================
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/initiate-auth.html#examples
#
## 使用 USER_PASSWORD_AUTH 方式認證並登入到 Cognito
aws cognito-idp initiate-auth \
  --auth-flow USER_PASSWORD_AUTH \
  --client-id $COGNITO_CLIENT_ID \
  --auth-parameters "USERNAME=cool21540125@gmail.com,PASSWORD=$PASSWORD" \
  --query 'AuthenticationResult.IdToken' \
  --output text
# 會拿到一包超級長的 token string (這就是 JWT Token)
# 不知道為啥, zsh 帶入 UserName 變數好像有點問題!? 所以直接寫死 email 了...
