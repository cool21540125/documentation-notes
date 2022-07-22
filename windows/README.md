# Windows 10 環境變數

```cmd
> echo %SYSTEMROOT%
C:\Windows

> echo %USERPROFILE%
C:\Users\tony
```


# Windows 10 檔案路徑

```
C:\Windows\System32\drivers\etc\HOSTS  # win10 的 /etc/hosts
```

# 認證

控制台/所有控制台項目/認證管理員/Windows認證


# Process

```cmd
### 等同於 linux 的 netstat | grep XXX
> netstat -ano | findstr :6007


### kill
> taskkill /PID XXX /F
```


# 快速存取

- 2018/06/21

不知道為啥, Windows10 原本設好好的 `快速存取` 裏頭的東西突然掛掉, 乾~  真的不知道為啥

解法: https://answers.microsoft.com/zh-hant/windows/forum/windows_10-start-winpc/win10%E6%AA%94%E6%A1%88%E7%B8%BD%E7%AE%A1%E7%9A%84/a2402019-d7aa-42cc-9eb6-600b885111c5

前往底下兩個資料夾位置, 把裡面的東西砍光~~~  就可以正常使用 `快速存取` 了!! 只是得再重新設定就是了orz
```
%AppData%\Microsoft\Windows\Recent\AutomaticDestinations
%AppData%\Microsoft\Windows\Recent\CustomDestinations
```


# 網路磁碟

- [Windows掛載、刪除網路磁碟net use指令](http://dannysun-unknown.blogspot.com/2017/10/windowsnet-use.html)
- 2018/11/08



```powershell
> net use
狀態   本機    遠端                         網路
-------------------------------------------------------------------------------
OK       R:    \\pomeswrd\87.documentation  Microsoft Windows Network
OK       S:    \\pomeswrd\96.softwares      Microsoft Windows Network
命令已經成功完成。
# 表示, 目前把 網路磁碟分別掛載到 Windows10 本地端的 R, S 槽

# 卸載 R 槽
> net use R: /delete
```


# Windows 10 的萬惡更新....

- 2018/06/21

常有一堆人說, 明明把 Windows 10 的更新關掉了, 但為什麼還是更新了?

又或者有人說, 設定暫停更新過大概30天後, 仍然會被強制更新, 這是為啥?

Ans:

因為多半只有動到這個...

Windows Update > 進階選項 > `暫停更新: 暫時暫停安裝更新最多達35天. 下次更新的時候, 需要取得最新的更新後, 才能再次暫停更新`

至於要再到哪裡把真正的更新服務給關了, 我猜應該是到

services.msc > Windows Update , 把這服務給關了 (我還沒實測過就是了...) 


# Win + R 

- pcpa.cpl        控制台\所有控制台項目\網路連線
- services.msc    系統服務


# C

- 2019/01/19
- [使用 VSCode 編譯並執行 C/C++ 語言](https://junyou.tw/vscode-c/)
- [使用 Visual Studio Code 寫 C/C++](https://blog.darkthread.net/blog/write-c-with-vscode/)

> 無意間, 不小心地找到 N 年前買的 大話資料結構, 然後經過了這個年頭的 Linux 巡禮, 感覺自己應該有能力去弄自己的開發環境了!! 開想說或許哪天, 應該要撥點時間來好好的 K 資料結構, 不然, 改天就喚它 K 我了!! 底下紀載如何在 `Windows 10` Programming C using VS Code

目前僅記錄... 改天真下定決心再來吧!~


## 環境

- [Windows 10 上的 gcc](https://sourceforge.net/projects/mingw-w64/)
- [編譯器基礎環境](http://releases.llvm.org/download.html)


## VSCode packages

- C/C++
- C/C++ Clang Command Adapter


# Other

3389 port, RDP (Remote Desktop Protocol)