# Storage Driver
- 來源: [Select a storage driver](https://docs.docker.com/storage/storagedriver/select-storage-driver/)
- 目的: `Storage Driver` 可控制 `Docker host` 如何來管理 `Docker images` 及 `Docker Containers`


## `Docker CE` 的 `Storage Driver` 還不是很穩定!(應該吧@@?  原文看下面)
```
Expectations for non-recommended storage drivers: Commercial support is not available for Docker CE, and you can technically use any storage driver that is available for your platform. For instance, you can use btrfs with Docker CE, even though it is not recommended on any platform for Docker CE, and you do so at your own risk.

The recommendations in the table above are based on automated regression testing and the configurations that are known to work for a large number of users. If you use a recommended configuration and find a reproducible issue, it is likely to be fixed very quickly. If the driver that you want to use is not recommended according to this table, you can run it at your own risk. You can and should still report any issues you run into. However, such issues have a lower priority than issues encountered when using a recommended configuration.
```


## Storage Driver
Storage Driver | Description
-------------- | ------------------------------------------------------------
btrfs |
zfs | 
overlay2 | 官方建議使用這個(if possible), 並且預設就是這個`
overlay | **最穩定**
devicemapper | **最穩定** 生產環境依賴於 *direct-lvm* ; 沒設組態的話, 效能極差
aufs | **最穩定**; 只支援 Ubuntu, Debian), 以現階段的版本來講, 這個使用起來有點麻煩... 還有相依套件等等(看官方了)
btrfs | 只支援 SUSE Linux Enterprise Server(SLES)
vfs | 官方不建議使用, 若要使用的話, 請先讀完[這個](https://docs.docker.com/storage/storagedriver/vfs-driver/#example-image-and-container-on-disk-constructs)

> Storage Driver 會被 `Kernel 版本`, `作業系統`, `Docker版本`, `檔案系統格式`, ... 所影響!!

Linux dist | 官方推薦的 storage drivers
---------- | -------------------------------------------------------------------------------------------
Ubuntu	   | aufs, devicemapper, overlay2 (Ubuntu 14.04.4 or later, 16.04 or later), overlay, zfs, vfs
CentOS	   | devicemapper, vfs

```sh
# 可以查看現在正在使用哪種 storage driver
$ docker info
...(略)...
Storage Driver: overlay2        # <--- 官方預設就是這個, CentOS7 官方建議改為 devicemapper 或 vfs
 Backing Filesystem: xfs
...(略)...
```

Storage driver    | 已支援的檔案系統格式
----------------- | -------------------------------------
overlay, overlay2 |	ext4, xfs
aufs              | ext4, xfs
devicemapper      | direct-lvm
btrfs             | btrfs
zfs               | zfs

如果 更改了 `Storage Driver`, 則已存在地 `Docker Images` 及 `Docker Containers` 都會無法存取!!

-----------------------------------------------------------------
## 備註
文中提到我看不懂的....

- block level
- file level