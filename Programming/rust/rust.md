
# rustc

```bash
### 官方建議安裝 rust 的方式 (for Unix)
# https://doc.rust-lang.org/book/ch01-01-installation.html
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
# 這個是使用 rustup 的方式來安裝


### 安裝完後, 設定 PATH
rustc --version
#rustc 1.76.0 (07dca489a 2024-02-04)

cargo --version
#cargo 1.76.0 (c84b36747 2024-01-18)


### rust 也需要 C compiler
xcode-select --install


### 可用來確認有無安裝 C compiler
xcode-select -p


### (若原本使用 rustup 安裝的話) 日後的 rust 升級 & 刪除
rustup update
rustup self uninstall


### (沒有網路的話) 查看 local 說明文件
rustup docs --book
```


# cargo

- cargo 是 rust 的 `build system` 及 `package manager`
- crate 是 rust 的 src code files 的 collections(crate 等同於 python 的 package)
    - cargo build 的產出物為 binary crate
    - 像是 `rand crate` 為 library crate (無法被直接執行)

```bash
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
```


# ownership

用來保證 rust 無需 gc 依然能夠達到 memory safety 的方式