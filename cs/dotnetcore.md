
# Startup.cs

- Program Entrypoint 後續的啟動配置
- IoC 註冊服務至 Container 相關


# Program.cs

- 程式進入點
- 初始化 Builder
- config 設定過程, 可能會依序載入 appsettings.json 或是 appsettings.{env.EnvironmentName}.json


# .vscode/tasks.json

- 本地使用 VSCode launch 服務時, 由 launch.json 裡頭的 debugger 配置所觸發
- 裡頭的 task 基本上都是: `dotnet build xxx.csproj /property:GenerateFullPaths=true /consoleloggerparameters:NoSummary`


# .vscode/launch.json

- vscode Local Debug 的運行設定檔
- 檔案內部的 Key-Value
    - preLaunchTask : 指向對應的 .vscode/tasks.json 內部的 Task
    - serverReadyAction : 運行後幫忙開啟瀏覽器
    - program 及 args : Run Server 的 Entrypoint
    - env : Run Server 帶入的環境變數


# appsettings.json 及 appsettings.*.json

- appsettings.json
- appsettings.Development.json
    - 跑容器化時, 似乎需要把此內容變成 {} 才可以正常運行
- appsettings.Production.json
- appsettings.Staging.json
- appsettings.Local.json
    - 什麼時候會用到這個? 現階段跑在 Container 裡頭時, 也會使用到這個


# XX.csproj

- 專案設定檔
- 紀錄 NetCore 版本
- 紀錄依賴套件版本 `ItemGroup.PackageReference[*]`


# 