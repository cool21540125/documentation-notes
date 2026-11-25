# prototype

建立一份可拋棄式的原型來呈現問題, 用來檢視 state model or logic(檢視狀態模型或邏輯) 是否符合邏輯, 或者查看 UI 樣貌

when: User 希望做合理性驗證 OR 呈現 UI 示意

---

## 使用 prototype SKILL 的重大前提

prototype 藉由操作, 透過 `State Machine` 模擬各種情境之下的變化.

- 如果重點放在 邏輯合理性/狀態轉換
  - LLM 會去參考 LOGIC.md
- 如果重點放在 UI
  - LLM 會去參考 UI.md
  - UI 裡頭有提供多種方案可以選擇

需要在 prompt 進行著墨, 讓 LLM 清楚知道到底要的是哪種 (自己要很清楚自己想確認什麼, 而非主動提及 'UI' 或者 '狀態')

兩者產出的 artifacts 可能截然不同. `如果描述的不清楚, LLM 可能會傾向: backend 選 LOGIC && frontend 選 UI`

## skill output artifacts 的準則

1. 東西要一眼就看得出來是草稿, 不會被視為是正式產出物
2. 能夠被很輕易的運行
3. 不做永久儲存 (操作時, 頂多用到 Memory 不動 Disk OR DB)
4. 重視功能, 不求精美
5. (logic) action OR (UI) switch 以後, 必須要能夠清楚看到完整狀態, 方便看得出哪裡變了
6. 收尾時
  - 驗證通過的決定 - 用於實作
  - prototype 本身不進 main Branch, 而是獨立的 feature Branch, 並在 issue 留下追蹤可以找到該 prototype
  - prototype SKILL 過程的 Q&A 需要記錄在 issue OR commit 裡頭 用於追蹤

# LOGIC

做一個 HTML 頁面, 按按鈕就能看狀態怎麼變, 用來抓業務邏輯的漏洞. 不寫程式的人也能操作, 驗證完的邏輯直接搬進正式程式, 頁面就丟掉

# UI

在現有頁面上做 3 個版面差很多的版本, 畫面底部有切換列, 用箭頭就能換著看. 選好之後, 把勝出的版本重新寫進正式程式, 其餘版本存到獨立分支
