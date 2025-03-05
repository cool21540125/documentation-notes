#!/bin/bash
exit 0
# Ngrok 官網 : https://dashboard.ngrok.com/get-started/setup/macos
# ----------------------------------------------------------------------------

ngrok --version
#ngrok version 3.16.0


### 配置(如果使用 anonymous, 最多九只能使用 6 hrs)
# 
ngrok config add-authtoken ${網頁上看到的Token}
#Authtoken saved to configuration file: "$HOME/Library/Application Support/ngrok/ngrok.yml"


### Ngrok Agent
ngrok http 8080

### Ngrok Agent + Basic Authentication
ngrok http 8000 --basic-auth '帳號:密碼'

### Ngrok Agent + Google OAuth 2.0
ngrok http 8000 --oauth google


### 診斷 Ngrok 狀況
ngrok diagnose