
- [gist - Go (Golang) GOOS and GOARCH](https://gist.github.com/asukakenji/f15ba7e588ac42795f421b48b8aede63)

使用各種 `go run` / `go mod download` / `go install` / `go build` 的時候, 就會直接用 `go get package@version` 的方式下載 library, 並且放到 `$GOPATH/pkg/mod/{packagePath}@{version}`

```bash
export GOBIN=""
# 如果有指定的話, 將 `go install` 的東西放到這 (而非 $GOPATH/bin)

export GOOS="xxx"
# GOOS 基本上會是: android / darwin / js / linux / solaris / windows / ...

export GOARCH="xxx"
# GOARCH 基本上會是: 386 / amd64 / arm / arm64 / ...
```
