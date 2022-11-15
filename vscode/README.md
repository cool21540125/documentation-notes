

# pylintrc

- 2019/04/30
- [14:10 附近開始](https://www.youtube.com/watch?v=6YLMWU-5H9o)

新增 `.pylintrc`

```sh
[MESSAGES CONTROL]
disable=all
enable=W,C,E

# Warnings
# Conventions
# Errors
# ex: enable=E
# 表示只啟用 Error 時才提示
```


# Remote debugging

- [Remove Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)

安裝 VSCode Remote Development 套件

可在 host, 執行 沒有安裝 VS Code 的 remote 端的程式

## prerequest
1. 兩部電腦 : make sure that identical source code is available (看不懂..)
2. Mac & Linux: `pip3 install ptvsd==3.0.0` ; Windows: `pip install ptvsd==3.0.0`
3. Remote : 開放 port 給 debugger 使用
4. Remote : 遠端電腦放這個
```py
import ptvsd

# Allow other computers to attach to ptvsd at this IP address and port, using the secret
ptvsd.enable_attach("my_secret", address = ('1.2.3.4', 3000))

# Pause the program until a remote debugger is attached
ptvsd.wait_for_attach()
```
5. 
6. 
7. 
8. 
9. 
10. 
11. 

乾~~ 我放棄了... 總共有 11個步驟 ㄇㄉ


## Debugging over SSH (to remote)

因為某些特定因素, 可能也得作加密連線, 來作遠端 debug... (內容 pass)
