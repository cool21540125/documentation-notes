
使用各種 `go run` / `go mod download` / `go install` / `go build` 的時候, 就會直接用 `go get package@version` 的方式下載 library, 並且放到 `$GOPATH/pkg/mod/{packagePath}@{version}`

```bash
export GOBIN=""
# 如果有指定的話, 將 `go install` 的東西放到這 (而非 $GOPATH/bin)


```
