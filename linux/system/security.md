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

# Capabilities

- [Understanding Linux Capabilities Series (Part I)](https://blog.pentesteracademy.com/linux-security-understanding-linux-capabilities-series-part-i-4034cf8a7f09)
- 2021/08/16

`Linux Capabilities` 被用來允許 *non-root users* 在沒有被提供 **root permissions** 的情況底下, 依然可執行 `privileges operation`

可從 map page 查看 capabilities 的詳細資訊, Linux Kernel 大約有 40 個 capabilities.

- 以 process 來說, 有底下 5 類的 capabilities:
    - Effective capabilities, CapEff : 將要被每個 privilege action 驗證的 capabilities (當 process/thread 需要執行 action, 則該 capability 需要在此集合內)
    - Permitted capabilities, CapPrm : 用來作為被賦予 當需要使用 syscall 時, 可得到必要權限的 capabilities
    - Inherited capabilities, CapInh 
    - Ambient capabilities, CapAmb
    - Bounding set, CapBnd : 僅用以表示 capabilities 的超集
- 以 executable 來說, 有底下 2 類:
    - Permitted capabilities, CapPrm
    - Inherited capabilities, CapInh

此外, 還有一個 有效位(effective bit) 可以來做設定

----------------------------

```bash
$ which capsh
/usr/sbin/capsh

$ ls -l /usr/sbin/capsh
-rwxr-xr-x. 1 root root 19896 Apr  1  2020 /usr/sbin/capsh

### Normal User
$ grep Cap /proc/$BASHPID/status
CapInh: 0000000000000000
CapPrm: 0000000000000000
CapEff: 0000000000000000
CapBnd: 0000003fffffffff
CapAmb: 0000000000000000

### Root User
$# grep Cap /proc/$BASHPID/status
CapInh: 0000000000000000
CapPrm: 0000003fffffffff
CapEff: 0000003fffffffff
CapBnd: 0000003fffffffff
CapAmb: 0000000000000000

### 上面的顯示結果, 不是給人看的, 必須 decode 才能有效讓人來作識別
$# capsh --decode=0000003fffffffff
0x0000003fffffffff=cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_linux_immutable,cap_net_bind_service,cap_net_broadcast,cap_net_admin,cap_net_raw,cap_ipc_lock,cap_ipc_owner,cap_sys_module,cap_sys_rawio,cap_sys_chroot,cap_sys_ptrace,cap_sys_pacct,cap_sys_admin,cap_sys_boot,cap_sys_nice,cap_sys_resource,cap_sys_time,cap_sys_tty_config,cap_mknod,cap_lease,cap_audit_write,cap_audit_control,cap_setfcap,cap_mac_override,cap_mac_admin,cap_syslog,35,36,37

$# capsh --decode=0000000000000000
0x0000000000000000=
```
