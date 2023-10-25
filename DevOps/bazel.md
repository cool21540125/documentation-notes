
# Bazel

load http_archive rule in WORKSPACE

Bazel calls your top-level source file a workspace, which contains other source files in a nested fashion. Your workspace is what builds your entire software by taking a set of inputs and generating the desired output.

---

bazel 為 build / test tool. 是個能夠容納大型專案的 build system. 類似工具有: gradle / make / maven

由更高層次的分類來說, bazel 屬於 artifact-based build system. 類似工具有: buck / pants

---

基本配置:

專案根目錄配置 WORKSPACE, 作為 bazel 尋找東西的 root

在 workspace 裡頭, bazel 會尋找 BUILD

BUILD file 由 `Starlank / Skylark` Language 撰寫 (此語言很像 python3)

---

BUILD 定義了 what to build && how to build

BUILD 裡頭定義了 targets

* build target 需要餵入 input artifacts, 而這些 inputs 包含了: source files / dependencies / options

* build rule 會定義 bazel 需要用的 build tools, 像是: compilers / linkers / configurations

---

bazel 的 build process

1. **Loads** BUILD
2. **Analyzes** inputs / dependencies && apply build rules && 生成 action graph
3. **Executes** 由 build inputs 開始執行 build actions 直到 build outputs 產出

---

bazel 讀取 `foo.bzl` 的時候, 便會建立 `var`

如果 `bar.bzl` 要使用 `foo.bzl` 的變數, 聲明方式: `load(":foo.bzl", "var1", "var2", "var3")`

此時, 這些載入的 variables 為 immutable

---

`BUILD` 與 `.bzl` 的差異

`BUILD` 藉由 call rules 來 register targets

`.bzl` 則提供了 constants / rules / macros / functions

`BUILD` 裡頭可任意使用 native functions / native rules (他們都是 global symbols)

`.bzl` 需要使用 native module 來載入他們

`BUILD` 裡頭無法:

- 定義 functions
- 使用 arguments


---



A package contains all your related files and dependencies and a file named BUILD. Subdirectories falling under a package are called subpackages.

```
src/app/BUILD
src/app/core/input.txt
src/app/tests/BUILD

# 包含了 2 個 packages
#   app
#   app/tests

# package 裡頭的 elements 稱之為 target, 可區分為
#   files
#   rules
```


Elements of a package are called targets, which can be categorized as files and rules.



- build/test tool
    - like make, maven, gradle

```bash
### mac/linux/windows 建議使用 Bazelisk 來控管 bazel 版本 (地位等同於 nvm)
### version


### 

```