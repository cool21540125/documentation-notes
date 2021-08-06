# 安全性相關

- 2018/06/09


# 檔案隱藏屬性 (我用 特殊屬性 來理解它...)

- [鳥哥 chattr](http://linux.vbird.org/linux_basic/0220filemanager.php#chattr)

IMPORTANT: 隱藏屬性對於 Linux 來說, 只能在 Ext2/Ext3/Ext4 中完整生效, 像是 CentOS7 預設使用的 `xfs`, 僅有部分支援

- `lsattr` : 查隱藏屬性
- `chattr` : 改隱藏屬性

```sh
$ touch qq
$ sudo chattr +i qq
$ rm qq
rm: 無法移除 'qq': 此項操作並不被允許

$ lsattr
----i----------- ./qq
```

最常用到的有:

- `chattr +a` 檔案 無法作 append 以外的事情, 且無法被刪除
    - 像是 log file, 建議可搭配此隱藏屬性來加以保護
- `chattr +i` 檔案 無法被 刪除, 更名, 設定連結, 等等操作
