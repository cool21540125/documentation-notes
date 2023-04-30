# C# .net core

- 2019/01/14

## CLI

```sh
### 查看CLI可建立那些APP
dotnet new -l

### 建立 APP && rename
dotnet new console -o myApp

### 執行
dotnet run

### version
dotnet --version

### 系統資訊
dotnet --info


### list all SDK
dotnet --list-sdks

### list all runtime
dotnet --list-runtimes


### 如果電腦有多個不同的 sdk version
dotnet new globaljson
# 編輯新生的 global.json 修改裡面的 version
#   版本可參考 dotnet --list-sdks

```