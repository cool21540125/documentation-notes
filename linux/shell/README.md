# bash腳本練習及備註

```sh
$ uname -a
Linux tonynb 3.10.0-693.21.1.el7.x86_64 #1 SMP Wed Mar 7 19:03:37 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

$ cat /etc/centos-release
CentOS Linux release 7.4.1708 (Core)
```


### `set -xe`

- [What does set -e mean in a bash script?](https://stackoverflow.com/questions/19622198/what-does-set-e-mean-in-a-bash-script)
- [What would set +e and set -x commands do in the context of a shell script?](https://superuser.com/questions/1113014/what-would-set-e-and-set-x-commands-do-in-the-context-of-a-shell-script)
- [Aborting a shell script if any command returns a non-zero value?](https://stackoverflow.com/questions/821396/aborting-a-shell-script-if-any-command-returns-a-non-zero-value/821419#821419)
- [Stop on first error](https://stackoverflow.com/questions/3474526/stop-on-first-error)
- [What does set -x do?](https://stackoverflow.com/questions/36273665/what-does-set-x-do)

- set
    - "-" : set the option
    - "+" : unset the option
    - `set -e` : 如果整個 ShellScript 流程非常嚴謹不容出錯, 就用這個(腳本中遇到任何指令執行後, exitCode 不為 0 則中斷)
    - `set -x` : makes the shell print out commands after expanding their parameters but before executing them
    - `set +x` : 像是在 JenkinsJob 裡頭執行 bash, 建議設定這個, 不然任何指令執行結果會被輸出以外, 指令字串本身還會被印出來(畫面會很亂)

```sh
# 常看到 ShellScript 出現 `set -xe`
-e  Exit immediately if a command exits with a non-zero status.
-x  Print commands and their arguments as they are executed.

# `set -e` 
# 腳本內如果出錯的話, 立即停止執行, 用來避免前期錯誤導致後續雪崩式的錯誤

# `set -x`
# 腳本內的任何指令時, 都會把它在 terminal 上印出來
```