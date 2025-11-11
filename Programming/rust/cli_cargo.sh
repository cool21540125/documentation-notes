#!/bin/bash
exit 0
#
#
# ------------------------------------------------------------------

cargo --version
#cargo 1.76.0 (c84b36747 2024-01-18)

### 建立 cargo project
cargo new PACKAGE_NAME


### 
cargo build            # for non prd -> target/debug/
cargo build --release  # for prd     -> target/release/


### 
cargo run


### 依照 carto.toml 裡頭的 deps, 查看 package 的說明文件
cargo doc --open 


### 不做 compile, 但做是否可 compile 的檢查
cargo check