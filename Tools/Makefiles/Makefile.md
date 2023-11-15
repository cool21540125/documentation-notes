- [GNU make](https://www.gnu.org/software/make/manual/html_node/index.html)
- [Makefile Tutorial](https://makefiletutorial.com/)


# Basic

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


# Fancy Rules

## Implicit Rules

- Make 因為與 C 及 C++ 有著深度的整合, 因此有了一系列的 implicit rules
	- `CC`       : 用來處理 C, 預設為 `cc`
	- `CXX`      : 用來處理 C++, 預設為 `g++`
	- `CFLAGS`   : 給 C compiler 的 extra flags
	- `CXXFLAGS` : 給 C++ compiler 的 extra flags
	- `LDFLAGS`  : 給 compilers 的 extra flags (當需要去 invoke the linker)
- Implicit Rules:
	- C : 由 **xx.c**            產出 **xx.o**
		- `$(CC) -c $(CPPFLAGS) $(CFLAGS) $^ -o $@`
	- C++ : 由 **xx.cc**/**xx.cpp** 產出 **xx.o**
		- `$(CXX) -c $(CPPFLAGS) $(CXXFLAGS) $^ -o $@`
	- Link Object File : 由 **xx.o** 產出 **xx**
		- `$(CC) $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS) -o $@`

```makefile
### C 與 C++ 的 Implicit Rule 範例
CC = gcc
CFLAGS = -g  # 啟用 debug info

blah: blah.o

blah.c:
	echo "int main() { return 0; }" > blah.c

clean:
	rm -f blah*
```



# CLI

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
