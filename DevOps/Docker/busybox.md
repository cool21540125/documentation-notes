
# busybox

- 人稱瑞士軍功刀. 基本功能一應俱全 的 輕量級 OS
- `/bin/*` 底下的執行檔, 基本上都是由 `/bin/busybox` 來實作
    - 可能透過 軟連結 or 硬連結
- buxybox 有支援(模擬 `httpd`)
    - 但是在 Apline Image 之中被移除了, 如果要自行安裝, 必須去抓~
        ```bash
        ### busybox Image 的 Container 內部
        $# wget https://busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-x86_64
        $# chmod +x busybox-x86_64
        $# mv busybox-x86_64 bin/busybox
        ```