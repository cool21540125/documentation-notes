# rust

- crates.io : Rust 套件倉庫 (可以理解成 PiPy 啦)
- Cargo : Rust 的 built-in package manager (理解成 npm 啦)


# cargo

- cargo 是 rust 的 `build system` 及 `package manager`
- crate 是 rust 的 src code files 的 collections(crate 等同於 python 的 package)
  - cargo build 的產出物為 binary crate
  - 像是 `rand crate` 為 library crate (無法被直接執行)

# ownership

用來保證 rust 無需 gc 依然能夠達到 memory safety 的方式
