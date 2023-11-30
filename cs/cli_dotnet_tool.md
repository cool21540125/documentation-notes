
`dotnet tool` 是特殊的 NuGet package, 其內涵可執行的 console App

與 NuGet 不同的是, 它並非與專案綁定

```bash
### ======================== dotnet tool ========================
### 1. 安裝到 global
dotnet tool install -g dotnetsay
# -g == --global
# 會安裝到 $HOME/.dotnet/tools/ 下

### 2. 指定安裝路徑
dotnet tool install --tool-path ~/bin dotnetsay


### 3. 如果要安裝到 project local
dotnet new tool-manifest
# 會建立 manifest file, 名為 ./config/dotnet-tools.json


### 安裝套件
dotnet tool install dotnetsay  # latest
dotnet tool install dotnetsay --version 2.1.4
dotnet tool install --global dotnetsay --version "*-rc*"  # latest rc


### 依照 manifest file 安裝依賴 (等同於 npm install)
dotnet tool restore


### 列出所有安裝的套件
dotnet tool list -g
dotnet tool list


### 調用套件
dotnet tool run dotnetsay
dotnet dotnetsay

# 以下三者相同
dotnet tool run dotnet-doc
dotnet dotnet-doc
dotnet doc


### 更新套件
dotnet tool update -g $PKG
dotnet tool update --tool-path $PKG
dotnet tool update $PKG


### 移除套件
dotnet tool uninstall -g $PKG
dotnet tool uninstall --tool-path $PKG
dotnet tool uninstall $PKG
```
