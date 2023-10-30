# Bazel

- bazel 為 build / test tool
- 基本上有 3 個動作: `bazel build`, `bazel test`, `bazel run`
    - 對於 `bazel build` 及 `bazel test` 需要是 no side-effect (為了有效 cache)
- `BUILD.bazel`, 稱之為 build file, 由 `Starlank/Skylark` 撰寫
    - 資料夾如果有此檔案, 則此資料夾就稱之為 `package`
    - 定義了這個 package:
        - how to build
        - what to build (稱之為 targets)
- `WORKSPACE` 目錄, 即為 root of the main repository, 也稱之為 '@'
    - 定義在 WORKSPACE 的 external repositories 會是下列兩者之一:
        - WORKSPACE 裡頭藉由 workspace rules 引用的
        - Bzlmod 系統中的 modules 及 extensions 產生

* build target 需要餵入 input artifacts, 而這些 inputs 包含了: source files / dependencies / options

* `build rules` 會定義 bazel 需要用的 build tools, 像是: compilers / linkers / configurations
    * 絕大多數情況下, 不需要自行實作 `build rules` (或稱之為 `Language rules`)
        * 此外還有 android rule / ios rule
    * 

---

bazel 的 build process

1. **Loads** BUILD
2. **Analyzes** inputs / dependencies && apply build rules && 生成 action graph
3. **Executes** 由 build inputs 開始執行 build actions 直到 build outputs 產出

- bazel run 將 input 轉換成 output 的動作稱之為 action
    - ex: compiling source file

---


```bzl
### BUILD.bazel
load("@rules_java//java:defs.bzl", "java_binary", "java_library")

java_library(
    name = "greeter",               # 
    srcs = ["Greeting.java"],
)

java_binary(
    name = "ProjectRunner",         # Target Name (基本上同 Artifacts)
    srcs = ["ProjectRunner.java"],
    deps = [":greeter"],            # 依賴於一系列的 Targets
)
```

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

```
src/app/BUILD
src/app/core/input.txt
src/app/tests/BUILD

# (放了 BUILD 的資料夾, 就會被視為是個 package) (同 python 的 __init__.py)
# 包含了 2 個 packages
#   app
#   app/tests

# package 裡頭的 elements 稱之為 target, 可區分為
#   files
#   rules
```


# .bazelrc

順序(後者會覆蓋前者)

1. `/etc/bazel.bazelrc`
2. workspace 的 `.bazelrc` (如果 cmd option 沒有 `--noworkspace_rc` 的話)
3. `$HOME/.bazelrc` (如果 cmd option 沒有 `--nohome_rc` 的話)
4. cmd line 明確指定 `--bazelrc=file`


# bazel CLI

- bazel build - https://bazel.build/run/build

> bazel build //Package:Target

```bash
### 產出 graphviz
bazel query --notool_deps --noimplicit_deps "deps(//...)" --output graph
# 貼到這吧 http://www.webgraphviz.com/
# --noimplicit_deps 'Target'


### 
bazel query --noimplicit_deps
```


# Additional Bazel tools

- buildifier
    - formatting + linting
- Starlark Lauguage & Build API
    - 可用來建立 custom rules
- Build Event Stream
    - 用來 monitor build events 及 identify bottlenecks
