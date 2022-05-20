# 不管命令有沒有錯誤, 執行就對了
new:
	touch abc

# 第一個指令就報錯, 後面停止執行
clean:
	rmdir orz
	rm -rf abc

# 雖然會報錯, 但是依舊會繼續執行
fclean:
	-rmdir orz
	-rm -rf abc
