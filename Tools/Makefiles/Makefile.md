- [GNU make](https://www.gnu.org/software/make/manual/html_node/index.html#SEC_Contents)

```makefile
# makefile 由一系列 rules 所組成
hello: prerequisites
	command  # step
	command  # step
	command  # step
# 此為 hello target (hello 同時也是這個 target 的 file name)
# rule 名為 hello
# rule 不一定要有 prerequisites (若有多個, 使用「 」分隔開來)


### (不常見的範例)
t1 t2:
    echo $@
# 上面這個 rule, 同時有 2 個 Targets
# $@ 指的是 Target 自身
```


## CLI

```bash
### 
make --version
#GNU Make 3.81
#Copyright (C) 2006  Free Software Foundation, Inc.
#This is free software; see the source for copying conditions.
#There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
#PARTICULAR PURPOSE.
#
#This program built for i386-apple-darwin11.3.0


### 
```
