# vim 指令

- 2018/08/03 update
- [vimrc設定教學](http://wiki.csie.ncku.edu.tw/vim/vimrc)
- [Vim Tips Wiki - All the right moves](http://vim.wikia.com/wiki/All_the_right_moves)

## Vim 設定檔

```sh
$ vi ~/.vimrc


set expandtab
set tabstop=4
set shiftwidth=4
set nu
set ai
set autoindent

set nocompatible


retab                  # 將文中所有tab換成空白
.retab                 # 將目前這行的tab換成空白

set ai  # 內縮

set autoindent         # 啟用自動縮排
set noautoindent       # 取消自動縮排

set syntax on          # 依照程式語言換顏色
set syntax off         # 不秀顏色

set ignorecase         # 搜尋不分大小寫
set noignorecase       # 搜尋區分大小寫(預設)

set cursorline         # 所在行會有底線

if has('mouse')
  set mouse=a          # 可以使用滑鼠點選位置(這有點猛)
endif
set mouse=""           # 取消滑鼠點選位置的功能

# Ubuntu Vim 相容模式 (Ubuntu Vim 超難用~)
set nocompatible

autocmd FileType yaml setlocal ai sw=2 ts=2 et
# enable auto-indenting, tab-stop and shift-width to be 2 spaces and tabs are saved as spaces in the file
```



# Vim 操作

## Vim 基本操作

```sh
### 模式切換
a               從目前游標 "之後" 開始輸入
i               從目前游標 "之前" 開始輸入

A               從目前游標 "所在行行尾" 開始輸入
I               從目前游標 "所在行行首" 開始輸入

o               從目前游標 "下一行插入一行" 開始輸入
O               從目前游標 "上一行插入一行" 開始輸入

R               Replace Mode (就... Insert模式) 不好用!


### 命令操作
:w              存檔
:w /tmp/qq      另存檔名為 /tmp/qq
:q!             不存檔離開
:x              存檔後離開
:e <filename>   開啟檔案
:e! <filename>  不存檔 && 開啟檔案


### 選取範圍
v               可逐字選取
V               一次選取整行
Ctrl+v          區塊選取 (這個猛!)


### 移動
gg              到 First Line
G               到 Last Line

8G              到 第8行
:8              到 第8行(同8G)

0               到 行首
$               到 行尾

w               到 下一次頭
b               到 前一字尾

(               到 current or previous 段落
)               到 next sentence

{               到 段首
}               到 段尾
V3}             目前行, 往下選取 3 段

%               到 相對應的 () [] {}


### Command Mode 編輯
D               刪 游標處 ~ 行尾
dd              刪 整行
5dd             刪 游標位置起往下 5 行
J               合併目前行與下行
~               目前選取的 character 作 大小寫轉換

p               貼上 (Ctrl + v 的概念)
3p              往後貼上 3 次
y               複製 (Ctrl + c 的概念)
x               剪下 (Ctrl + x 的概念)
u               undo (Ctrl + z 的概念)
.               redo (Office裏頭, F4 的概念)
`Ctrl+r`        redo undo (復原 按了太多次... 回復上一個動作)


### 頁面捲動
Ctrl + B        page up
Ctrl + F        page down
Ctrl + Y        view pane up
Ctrl + E        view pane down


### Ex Mode 編輯
:6,9d            刪 6~9行


### Terminal底色
:set bg=dark
:set bg=light


### 改變 win & unix 格式
:set fileformat:unix


### 搜尋
/cfg            尋找 「cfg」關鍵字
/\ccfg          不分大小寫, 搜尋「cfg」
n               尋找 下一個
N               尋找 上一個
:noh            取消搜尋
```


## Vim 進階操作

Vim 有 26 個 named registers, 可以把 `複製的東西`, 塞到 各個命名剪貼簿

```
"ny             把目標範圍 複製後註冊到 名為 n 的 named register
"np             從名為 n 的 named register, 貼上

5"qyaw          Copy 5 個完整的字, 存到 q 剪貼簿
"qp             從名為 q 的 named register, 貼上
```


### Search and Replace

Vim + re 語法 : `ranges/pattern/string/flags`

`ranges` 的 `s` 為 search and replace command (固定要有的字啦)

重點就是 : `:s///` 一定要有

- range: Line Number(ex: `42`) 或 Line Numbers(ex: `1,7` 表示1-7行) 或 目標單字 (ex: `README\.txt`) 或 全文: `%` 或 `'<`, `'>` for the current visual selection
- pattern :
- string :
- flags : `g`, `i`
    - g : replacing more than one occurrence of pattern per line (每行多次)
    - i : 不分大小寫

```sh
# 使用方式, 先使用 Visual Mode 選好特定範圍後, 在進入 Ex Mode, Syntax Pettern 會自己帶出來

# 全文, 不分大小寫, 每行可多次執行, 找到 字首c 字尾t, 取代成 dog
:%s/\<cat\>/dog/gi

# 第 18 行, 所有的 the 取代成 abc
:18s/the/abc/g
```


## Vim 超進階操作

Vim 有 10 個 numbered registers, 由 `"0` ~ `"9`

Vim歷史操作紀錄, 都放在 `~/.viminfo`


## Color Theme

- [挑選 Vim 顏色(Color Scheme)](https://blog.longwin.com.tw/2009/03/choose-vim-color-scheme-2009/)

```sh
# CentOS7 內建的 vim color theme
$ ls /usr/share/vim/vim74/colors
blue.vim      default.vim  desert.vim   evening.vim  morning.vim  pablo.vim      README.txt  shine.vim  torte.vim
darkblue.vim  delek.vim    elflord.vim  koehler.vim  murphy.vim   peachpuff.vim  ron.vim     slate.vim  zellner.vim

# 使用 xxx theme
$ vim ~/.vimrc
colo evening
color desert
syntax on
```
