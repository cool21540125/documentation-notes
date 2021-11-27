
## RH134-RHEL7-en-1-20140610, p64 範例

```sh
# 若一次性排程工作 > 0, bash 就睡覺吧~
while [ $(atq | wc -l) -gt 0 ]; do sleep 1s; done
```


```bash
# -e: 可以啟用 \ 轉譯
echo -e "\033[31m[ERROR]\033[0m"
# 會印出 紅色字體的 [ERROR]

echo -e "\033[32m [INFO]: hi \033[0m"
# 印出 綠色字體 [INFO]: hi
```


# if

- if -d : 為 dir
- if -e : 檔名是否存在
- if -f : 檔名是否存在 && 為 file
- if -L : 為連結
- if -n : 長度 > 0
- if -o : 多重條件 or
- if -r : readable
- if -s : 大小 >0
- if -w : writable
- if -x : executable
- if -z : 字串長度為 0, 回傳 true


# 

```bash
# 來自 https://github.com/docker-library/mongo/blob/be84ebdc31c9761833412215d3d2f60538ee9f5a/4.4/docker-entrypoint.sh
if [ "${1:0:1}" = '-' ]; then
	set -- mongod "$@"
fi
```


# ShellScript

### IFS 用途

> If IFS is unset, the parameters are separated by spaces

```bash
$ set -- one two three
$ IFS=hello
$ echo "$*"
onehtwohthree
$ unset IFS
$ echo "$*"
one two three
```

### 