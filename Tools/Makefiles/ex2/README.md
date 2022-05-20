# .PHONY 用途

假如 Makefile 有兩個工作階段
- new: touch clean
- clean: rm -rf clean

在還沒有定義 `.PHONY: clean` 以前

`make clean` 會看到 **`clean' is up to date.**

make 會誤把 clean 視為 file

因此若把 clean 加入到 PHONY, 就是告知 make

clean 是個工作階段

使用的前提是: 如果 working directory 有 「與工作階段同名的檔案」

就把這個 工作階段名稱 加入到 PHONY 就是了~
