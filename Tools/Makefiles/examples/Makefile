#!/usr/bin/make -f

files := file1 file2

.PHONY: some_file file1 file2 clean

some_file: $(files)
	echo "Look at this variable: " $(files)
	touch some_file

file1:
	touch file1

file2:
	touch file2

clean:
	rm -f file1 file2 some_file

# ------------------------------------------------------------

.PHONY: test1 test2

foo1 = World
foo2 = one $ two
foo3 = one $$ two
# NOTE: 變數裡面要有 $ 字串的話, 需要使用 $$

test1:
	@echo "foo1=$(foo1)"
	@echo "foo1 (again)=${foo1}"
	@echo "foo2=$(foo2)"
	@echo "foo3=$(foo3)"
# 使用 Variables
	@echo "Hello $(foo1)!"
	@echo "Hello $(no_such_variable)"

# 使用 list
objects = text/1.txt text/2.txt text/3.txt

test2 : $(objects)
	echo '' > text/combined.txt
	cat $(objects) > text/combined.txt

$(objects) : text/demo.txt
	@echo "from $$ objects -> $(objects)"

req1:
	@echo "req1"
req2:
	@echo "req2"

target_name123: req1 req2
	@echo "Target Name : $@"
	@echo "First $<"
	@echo "Changed $?"
	@echo "all $^"

# -------------------------------
.PHONY: test9
list1 = text/*.txt
list2 = $(wildcard text/*.txt)
list3 = $(shell ls text/*.txt)
list4 != ls text/*.txt
# list4 這種用法只能在 make v4.2+ 才有效果
# 或者可用 gmake test9

test9:
	@echo "list1=$(list1)"
	@echo "list2=$(list2)"
	@echo "list3=$(list3)"
	@echo "list4=$(list4)"