# gettext 工具之一 - enbsubst

- Example: https://github.com/drone/envsubst/blob/master/readme.md
- Go 實作 enbsubst: https://pkg.go.dev/github.com/drone/envsubst?utm_source=godoc

可藉由 CLI, 把文字內容當中以 `$VAR / ${VAR}` 表示的環境變數佔位符, 替換成當前環境變數值的工具, 常用來生成動態配置文件.

