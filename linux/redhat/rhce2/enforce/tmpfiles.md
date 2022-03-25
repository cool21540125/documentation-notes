# Temporary Files

- 2018/11/13

作業系統內, 經常會有許多拉基東西, 放著無感, 多了礙事, 少了也無痛.

CentOS7 開機之後, 第一支程序 `systemd` 會去啟動 `systemd-tmpfiles-setup`, 而此服務會執行 `systemd-tmpfiles --create --remove`. 這指令會(依序)去讀取底下 3 個地方的設定檔:

- `/etc/tmpfiles.d/*.conf`
- `/run/tmpfiles.d/*.conf`
- `/usr/lib/tmpfiles.d/*.conf` : `rpm` 會來這邊更新(無論如何, 別手動更改這裡的東西!!)

    若存在 abc.conf 在下列兩個地方
    /etc/tmpfiles.d/abc.conf        ← 此優先適用
    /usr/lib/tmpfiles.d/abc.conf    ← 不會被採用


被這些定義檔所標示的資料夾, 被標示為刪除者會被刪除, 被標示為建立者則會被建立.

以上廢話那麼多, 主要目的就是, 藉由此設定操作, 系統會去清理一些地方, 以免磁碟被塞爆啦!!

# 談談 time 屬性

Linux 作業系統有 3 種時間:

- atime : 最近一次讀取時間
- mtime : 最近一次內容修改時間
- ctmie : 最近一次檔案屬性修改時間

講這幹嘛? 前面提到的 `systemd-tmpfiles` 會去找 特定資料夾底下(ex: /tmp)的檔案們的 3 種時間, 都比 `systemd-tmpfiles` 所設定的時間都還要早(檔案太久沒人去動它了), 則該檔案會被清除~~

--- 

像是 `/usr/lib/systemd/system/systemd-tmpfiles-clean.timer`:

```sh
[Unit]
Description=Daily Cleanup of Temporary Directories
Documentation=man:tmpfiles.d(5) man:systemd-tmpfiles(8)

[Timer]
OnBootSec=15min         # 開機後 15 分鐘
OnUnitActiveSec=1d      # 之後每隔 1 天
```

# systemd-tmpfiles config

```sh
#1  2                   3       4       5       6       7
d   /run/systemd/seats  0755    root    root    -
# 1 : Type
#   d : 若該資料夾存在, 不做事; 否則建立資料夾
#   D : 若該資料夾存在, 清空內容; 否則建立資料夾
#   L : 建立軟連結
#   Z : recursively 重新貼標(SELinux contexts)、file permissions、ownership
# 2 : Path
# 3 : Mode
# 4 : UID
# 5 : GID
# 6 : Age
# 7 : Argument

```

