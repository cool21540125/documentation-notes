# Typescript

- 所有 ts 代碼都需要經過編譯成 js 才能夠運行. 所有 ts 專案基本上都需要安裝 `typescript` 套件, 該套件提供了指令工具 `tsc` 用來將 ts 編譯為 js
    - 專案也可以不安裝 typescript, 僅僅透過 esbuild 也可以用來編譯 TS, 但 typescript 內建了型別檢查, 因此基本上都會需要用到它
- 開發 ts 代碼階段, 經常會使用特定工具, 直接運行 ts 代碼來做開發及除錯: `ts-node` OR `tsx`. 而兩者通常是可相互替代的.

Tools           | Dependency | Usage                | Substitute
--------------- | ---------- | -------------------- | -----------------------
typescript(tsc) | null       | Official TS compiler | 部分可被 esbuild 取代
ts-node         | typescript | execute TS           | 可被 tsx 取代
tsx             | esbuild    | execute TS           | 可被 ts-node 取代
esbuild         | null       | compile/bundle       | 部分可替代 tsc build


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