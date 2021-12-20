
### vim 常用
cat <<EOF >> ~/.vimrc
set shiftwidth=4
set tabstop=4
set expandtab
EOF

### vim 常用

# -----------------------------------------
set shiftwidth=4
set tabstop=4
set expandtab          # 使用 tab 的話, 以 whitespace 取代 tag

# set autoindent          # 別用. 如果貼上縮排程式碼, 會整個跑版

set ignorecase         # 搜尋不分大小寫
set noignorecase       # 搜尋區分大小寫(預設)

#if has('mouse')
#  set mouse=a          # 可以使用滑鼠點選位置(這有點猛)
#endif

autocmd FileType yaml setlocal ai sw=2 ts=2 et
# enable auto-indenting, tab-stop and shift-width to be 2 spaces and tabs are saved as spaces in the file

#set cursorline         # 所在行會有底線
#set nu                 # 行號
#set ai                 # 自動內縮

#set nocompatible       # Ubuntu

#retab                  # 將文中所有tab換成空白
#.retab                 # 將目前這行的tab換成空白