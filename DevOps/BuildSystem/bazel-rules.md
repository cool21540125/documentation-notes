# Bazel Rules

## General Rules

- alias
- config_setting
- filegroup
- genquery
- genrule
- starlark_doc_extract
- test_suite

## Platforms and Toolchains Rules

- constraint_setting
- constraint_value
- platform
- toolchain
- toolchain_type

## Workspace Rules

- bind
- local_repository
- new_local_repository

# 寫法

```
xx = rule(
  implementation = xx,
  attrs = {
    "xx": xx
  }
)

rule() 返回規則物件
```
