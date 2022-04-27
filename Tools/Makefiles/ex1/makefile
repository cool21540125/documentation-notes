all: f1
	@echo recipe \`\`all\'\' executed.
f2:
	@echo process 2:
	touch f2
f1:
	@echo process 1:
	touch f1
clean:
	rm f1
	rm f2
.PHONY: clean
# PHONY 用來定義 假工作目標, 若不這樣定義, 會讓 makefile 誤以為 'clean' 是個 file
# 最簡單的做法, 把上面的每個 make 工作階段的命令, 全部寫道 .PHONY 就是了