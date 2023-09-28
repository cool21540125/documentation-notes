#!/usr/bin/env bash
exit 0
# ------------------------------------------------------------------

### ======================== 系統及版本 ========================
### list all SDK
dotnet --list-sdks

### list all runtime
dotnet --list-runtimes

### version
dotnet --version

### show all dotnet system information
dotnet --info


### ======================== Create Project & Settings ========================
### 約束目前專案使用的 sdk 版本
dotnet new globaljson --sdk-version $SDK_VERSION


### 查看 CLI 可建立那些APP
dotnet new -l


### 建立新專案
# dotnet new {專案類型} -o {專案名稱}
dotnet new console -o xxx
dotnet new xxx --sdk-version $SDK_VERSION


### ======================== dotnet tool ========================
### 安裝 dotnet tool: lambda
dotnet tool install -g Amazon.Lambda.Tools
# 會放到 $HOME/.dotnet/tools/ 下


### 使用 dotnet tool: lambda 將專案打包成 zip
dotnet lambda package


### 
dotnet lambda help


### ======================== build & run ========================
dotnet build
dotnet publish


### 推送 library 到 nuget
dotnet pack
dotnet nuget push XXX.nupkg -k $NUGET_API_KEY -s $NUGET_SERVER