
# Bazel

load http_archive rule in WORKSPACE

Bazel calls your top-level source file a workspace, which contains other source files in a nested fashion. Your workspace is what builds your entire software by taking a set of inputs and generating the desired output.

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


- build/test tool
    - like make, maven, gradle

```bash
### mac/linux/windows 建議使用 Bazelisk 來控管 bazel 版本 (地位等同於 nvm)
### version


### 

```


# note

```bash
bazel build xx:all
# :all 是個 meta-target
```


# .bazelrc

順序(後者會覆蓋前者)

1. `/etc/bazel.bazelrc`
2. workspace 的 `.bazelrc` (如果 cmd option 沒有 `--noworkspace_rc` 的話)
3. `$HOME/.bazelrc` (如果 cmd option 沒有 `--nohome_rc` 的話)
4. cmd line 明確指定 `--bazelrc=file`