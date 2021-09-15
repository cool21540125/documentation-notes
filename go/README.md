- `Go routine` 是個輕量版的 thread, Golang 用它來 enable `concurrency`


```bash
### 
go mod init PackageName

### 自動下載相依檔, 並更新到 go.mod
go mod tidy

### 有點類似 python 的 venv , 自動下載到 local 的 vendor/ (裡面會有相依檔)
go mod vendor
```