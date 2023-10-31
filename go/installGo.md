

# Bazel 相關 - Install Gazelle / Install buildifier

- https://earthly.dev/blog/build-golang-bazel-gazelle/
- `gazelle` 是 Golang 的 BUILD file generator

```bash
### bazel 的 BUILD file generator
go install github.com/bazelbuild/bazel-gazelle/cmd/gazelle@latest


### bazel BUILD 的 formatter 及 linting tool
go install github.com/bazelbuild/buildtools/buildifier@latest
```
