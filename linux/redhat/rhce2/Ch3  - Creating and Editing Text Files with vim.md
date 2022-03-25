# Ch3  - Creating and Editing Text Files with vim

## vim 大量取代

Vim + re 語法 : `ranges/pattern/string/flags`, 一定要有`s///`

- range: Line Number(ex: `42`) 或 Line Numbers(ex: `1,7` 表示1-7行) 或 目標單字 (ex: `README\.txt`) 或 全文: `%` 或 `'<`, `'>` for the current visual selection
- pattern : 
- string : 
- flags : `g`, `i`
    - g : replacing more than one occurrence of pattern per line (每行多次)
    - i : 不分大小寫


vim 開啟 /lab/SearchAndReplace.txt

```sh
# 把 README 取代成 PLEASE_READ_ME
:%s/README/PLEASE_READ_ME/g

# 不存檔離開
:q!
```