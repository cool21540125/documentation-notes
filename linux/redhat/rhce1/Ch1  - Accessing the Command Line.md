# Terminal 的熱鍵操作

- `Ctrl + u` : 刪游標左邊
- `Ctrl + k` : 刪游標右邊
- `Ctrl + w` : 刪游標最近一個單字片段
- `Ctrl + ←` : 往左移動一個單字
- `Ctrl + →` : 往右移動一個單字
- `Alt + .` 或 `Esc + .` : Copy the last word of the previous command on the current command
- `Ctrl + l` : 把畫面清空

用下面的指令(複製貼上後, 別按Enter), 來測試上面的熱鍵操作

```sh
$ find /etc -name passwd > correct 2> /dev/null
```
