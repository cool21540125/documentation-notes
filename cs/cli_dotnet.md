
- 2023/05/05

## 起手式 & 查詢

```sh
### 如果電腦有多個不同的 sdk version
dotnet --list-sdks
dotnet new globaljson --sdk-version 3.1.426  # 生成 global.json (裡頭約束使用 3.1.426 版的 sdk)


### 查看CLI可建立那些APP
dotnet new -l


### 建立新專案
dotnet new console -o myApp
dotnet new xxx --sdk-version $dotnet_sdk_version


### 系統資訊
dotnet --info


### list all SDK
dotnet --list-sdks


### list all runtime
dotnet --list-runtimes


### 

```


# 運行

```bash

### 執行
dotnet run


### version
dotnet --version


### 

```
