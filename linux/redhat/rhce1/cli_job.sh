#!/bin/bash
exit 0
# ------------------------------------------------------------------------------------------

### 列出所有 $USER SESSION 底下的 jobs
jobs

### 將背景 job 1 呼叫到前景來 (Terminal 會 hanging)
fg %1
# 如果要暫停該 job, 則用 `Ctrl + z`, 該 Job 會被 Suspend (也就是 Stopped 了啦!)
# 如果要將該 job 丟回背景, 則輸入 `bg` 或 `bg %1` (會變回 Running)

# 想 暫停 的話, 其中一種方法, 就是把他們從 bg 拉到 fg, 再 Ctrl+z    暫停程式
# 想 結束 的話, 其中一種方法, 就是把他們從 bg 拉到 fg, 再 Ctrl+c    中斷程式

### 查看 projcesses 與 jobs 關係
ps j
