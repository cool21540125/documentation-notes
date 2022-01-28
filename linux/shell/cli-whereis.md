# whereis

> 只會去尋找`特定目錄`, 主要針對 `/bin`, `/sbin`, `/usr/share/man` 等資料夾作搜尋而已, 可用 `whereis -l` 來看究竟找了那些資料夾

```sh
$# whereis [-bmsu] <file or dir>

$# whereis ifconfig
ifconfig: /usr/sbin/ifconfig /usr/share/man/man8/ifconfig.8.gz
```