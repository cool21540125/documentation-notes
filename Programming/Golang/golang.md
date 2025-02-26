
- [gist - Go (Golang) GOOS and GOARCH](https://gist.github.com/asukakenji/f15ba7e588ac42795f421b48b8aede63)

使用各種 `go run` / `go mod download` / `go install` / `go build` 的時候, 就會直接用 `go get package@version` 的方式下載 library, 並且放到 `$GOPATH/pkg/mod/{packagePath}@{version}`


# variables

- `GOHOSTOS`   : darwin | windows | linux
- `GOBIN`      : 用來額外指定 `go install` 放置的位置 (否則使用預設的 `$GOPATH/bin`)
- `GOOS`       : 基本上會是: android | darwin | js | linux | solaris | windows
- `GOARCH`     : 386 | amd64 | arm | arm64
- `GOHOSTARCH` : arm64 | amd64
