#!/bin/bash
exit 0
# -------------------------------------------

### ============================== Cognito User Pool, CUP login 登入 ==============================
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/initiate-auth.html
### Login to cognito user pool
PASSWROD=
CognitoAppClientId=
aws cognito-idp initiate-auth \
  --auth-flow USER_PASSWORD_AUTH \
  --client-id $CognitoAppClientId \
  --auth-parameters USERNAME=tonychoucc@gmail.com,PASSWORD=$PASSWORD
# AuthenticationResult:
#   AccessToken: aaa.bbb.ccc  <-- JWT
#   ExpiresIn: 3600
#   IdToken: ddd.eee.fff  <-- JWT
#   RefreshToken: ggg.hhh.iii.jjj.kkk
#   TokenType: Bearer
# ChallengeParameters: {}
# ----- 上面是正常登入後看到的結構 ; 下面是首次登入, 必須重設密碼的情況
# 如果看到 NEW_PASSWORD_REQUIRED, 表示須要重設密碼, 需要拿那個非常長的 SESSION 到下面指令去改密碼

### 變更 CUP 密碼
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/respond-to-auth-challenge.html
aws cognito-idp respond-to-auth-challenge \
  --client-id "$CognitoAppClientId" \
  --challenge-name NEW_PASSWORD_REQUIRED \
  --challenge-responses USERNAME=tonychoucc@gmail.com,NEW_PASSWORD="1qaz@WSX",userAttributes.name=tonychoucc \
  --session "$SESSION"
# 靠北, userAttributes.name=tonychoucc 這東西官網文件根本沒寫, 浪費我一堆時間
