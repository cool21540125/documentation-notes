
- typescript 對應 javascript 的 7 種 原始資料型別(premitive):
    - null
    - undefined
    - boolean
    - string
    - number : ex: `1337`
    - bigint : ex: `1337n`
    - symbol


# 錯誤

- 語法錯誤 (Syntax Error) : 可能造成無法編譯, 不過 ts 編譯器仍會盡他所能的編譯出來 (無法被成功執行)
- 型別錯誤 (Type Error)   : 通常可能造成意外, 但此錯誤不影響編譯.


```ts

// 底下範例稱之為 型別註記
let people = "Tony";  // type: string


```