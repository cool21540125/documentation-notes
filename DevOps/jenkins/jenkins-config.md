

```bash
### 配置路徑 Mac
cd /usr/local/opt/jenkins-lts
# 服務配置在此, brew services 可以找到
# 啟動後, 會出現在 ~/Library/LaunchAgents
# 因此無法作為 LaunchDaemons
# 如果希望變成 LaunchDaemons, 需要丟到 /Library/LaunchDaemons/xxx.plist
```


# 設定 Jenkins URL

Dashboard > Manage Jenkins > Configure System > 

在 「Jenkins URL」裡頭, 輸入訪問的 Jenkins Server 的 URL

如果沒這麼做, (好像)不會怎樣, 只是 Jenkins 會一直跳出警告, 是否會導致其他錯誤目前還未知


# 設定 Credentials

Dashboard > Manage Jenkins > Credentials >

Stores scoped to Jenkins >  System > Global credentials (unrestricted) > (右上角) Add Credentials


# 
