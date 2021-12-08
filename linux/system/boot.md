# 開機相關

## 開機管理程式 grub

- 早期: `grub1`, `LILO`, `spfdisk (台灣很多人用)`
- 近期: `grub2`

```sh
# 開機載入程序
$ /etc/rc.d/rc.local  # or /etc/rc.local

# 重新啟動系統登錄檔(os6)
$ /etc/init.d/rsyslogd restart
```

`/etc/init.d/*` 這舊時代的 `systemV` 已經被新一代的 `systemd` 取代了



# BIOS 與 UEFI

- 2018/04/21

開機時, 會先跑一段 `開機程序`, 來載入 `硬體驅動程式`, 再載入 `作業系統`, 好讓作業系統可以控制硬體... (流程應該是這樣沒錯吧@@!?) 而讓電腦載入*硬體驅動程式*方面的程序, 主要有`早期的BIOS` 與 `較新的 UEFI` 兩種機制.


## 專有名詞

CMOS: 紀錄各項硬體參數, 且嵌入在主機板上的`儲存器`

BIOS: 寫入在主機板上的韌體(寫在硬體上的軟體)

Boot Loader: 開機管理程式

UEFI(Unified Extensible Firmware Interface): 統一可延伸韌體介面


## 開機流程 (不專業且不負責任的說明)

電腦開機後, 電腦主動執行的第一個程式為 `BIOS`. 它會去搜尋能夠開機的磁碟, 並找出第一個磁區, 然後叫 `MBR裏頭的 開機管理程式` 起床工作, BIOS就去洗洗睡了. 

緊接著, `開機管理程式`(安裝作業系統的時候, 一併安裝的東西) 的目的是 載入 `核心檔案`. 簡單的說, 輪到 `開機管理程式` 叫醒 `核心檔案` 起床工作, 然後 `開機管理程式` 又回去睡覺了.

後續, `開機管理程式` 的功能, 就是 `選擇不同的開機項目`(多重開機)、載入核心檔案、轉交其他loader(電腦有 2個以上的`開機管理程式`)

![Boot Loader](http://linux.vbird.org/linux_basic/0130designlinux/loader.gif)

- 每個分割槽, 都有自己的 `開機磁區(boot sector)`
- 可開機的核心檔案, 放置在各自的分割槽內.
- loader指認是自家的 `可開機核心檔案` 及 `其他家的 loader`

總之, 上面的重點只要知道~~~~~ 1. 開機需要 `開機管理程式(Boot Loader)` 以及 2. `開機管理程式(Boot Loader)` 可以安裝在 MBR 及 Boot Sector 兩個地方.


## [UEFI](https://www.techbang.com/posts/4361-fully-understand-uefi-bios-theory-and-actual-combat-3-liu-xiudian)

因為 BIOS 只是個 16bits的老舊程式, 他根本不會懂 64bits的 GPT, 所以比較新品種的 UEFI(又稱為 UEFI BIOS)就此誕生!!


## 備註

Boot Loader除了安裝在 MBR以外, 也可以安裝在 `每個分割槽的開基磁區(boot sector)`
