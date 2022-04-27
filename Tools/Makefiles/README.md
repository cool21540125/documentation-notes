# makefile

- [GNU make](https://www.gnu.org/software/make/manual/html_node/index.html#SEC_Contents)

Makefile 是用來管理 編譯 的軟體


## 摘要

makefile 由 **rules** 所組成

```makefile
target1 ... : prerequest ...
    # ↓ 命令行
    recipe
    ...
    ...
    # ↑ 命令行
target2 ...: prerequest ...
    # ↓ 命令行
    recipe
    ...
    ...
    # ↑ 命令行
```


## Example

### [Examle-CleanCodeInPython](https://github.com/PacktPublishing/Clean-Code-in-Python/blob/master/Makefile)


```bash
### 執行 Makefile 裏頭第一個 target
$# make

### 執行 Makefile 裏頭的 install instruction 這個 target
$# make install

### 
$# make
missing separator stop
# 要注意 makefile 裡頭的 **命令行部分**, 是否都是 tab 開頭!
```