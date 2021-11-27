# bash腳本練習及備註

```sh
$ uname -a
Linux tonynb 3.10.0-693.21.1.el7.x86_64 #1 SMP Wed Mar 7 19:03:37 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

$ cat /etc/centos-release
CentOS Linux release 7.4.1708 (Core)
```


### `set -xe`

- [What does set -e mean in a bash script?](https://stackoverflow.com/questions/19622198/what-does-set-e-mean-in-a-bash-script)
- [Aborting a shell script if any command returns a non-zero value?](https://stackoverflow.com/questions/821396/aborting-a-shell-script-if-any-command-returns-a-non-zero-value/821419#821419)
- [Stop on first error](https://stackoverflow.com/questions/3474526/stop-on-first-error)
- [What does set -x do?](https://stackoverflow.com/questions/36273665/what-does-set-x-do)

```sh
# 常看到 ShellScript 出現 `set -xe`
-e  Exit immediately if a command exits with a non-zero status.
-x  Print commands and their arguments as they are executed.

# `set -e` 
# 腳本內如果出錯的話, 立即停止執行, 用來避免前期錯誤導致後續雪崩式的錯誤

# `set -x`
# 腳本內的任何指令時, 都會把它在 terminal 上印出來
```