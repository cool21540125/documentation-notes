# grilling

毫不留情的拷問 user 關於 plan / decision / idea

trigger when User 希望對於一些想法做壓力測試

---

核心目的是, 讓 LLM 與 user 取得 `shared understanding`. 將其會製成 `design tree`

Work the tree in rounds.

每個決策都會分支出與其相關的決策
Map this as a `design tree`: every decision branches into the decisions that hang off it.

對於要開始展開問題的問題, Matt 把它稱之為 `frontier`, 便是讓 LLM 可以進行自問自答(合理推測) user 所隱含的資訊. 用這樣的資訊進行提問並且附上自己的答覆 (選擇 or 是非)

Q1 可能會有 A1 & A2 這兩種答案. 不過

- Q21 必須要 Q1 答案是 A1 才有意義
- Q22 必須要 Q1 答案是 A2 才有意義

因為 Q21 & Q22 都依賴於 Q1, 因此必須要先問出 Q1, 才能夠繼續選擇要問 Q21 or Q22

這個 SKILL 會不斷地問不斷地問, 直到把整個 design tree 的決策都問出來為止.

---

LLM 提問過程中對於 facts 有疑問, 從上下文 or 環境及工具當中尋找答案是 LLM 的職責, LLM 不可以對 user 提問任何可以自行求證的資訊

fork new agents 進行排查, 並且 main agents 可以繼續提問其他問題避免問題阻塞

對於任何問題, 最終決策權保留在 user 手上

當 `decision tree` 每個分支都已經被遍歷完畢, 沒有任何未加假設的內容時, SKILL session 宣告結束.

與 user 還沒達成 shared understanding 以前, LLM 不得採取行動.
