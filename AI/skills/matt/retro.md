# retro

Conduct a retrospective on a coding session.

每次 session 結束前, user 自行調用, 用來優化 coding agent's 的環境, 改善 future runs

---

## Steps

1. call `writing-for-agents` 寫作風格
2. 結束這輪 session 做檢討以前, 先審視 user 指定的情境 or Current session 的完整對話紀錄; 不要憑印象也不要憑摘要
3. 尋找值得優化的地方:
  - `Navigation` : 確認 agent 找東西的時候是否順暢 (避免 hidden dependencies)
    - 若不順暢, 那加上 **navigation pointer** 是否能夠找得更順暢?
  - `Automated checks` : agent 犯過的錯, 能否藉由 `自動化程式` 找出來?
    - 尋找 package.json / pyproject.yaml / ... 等 Build tool, 或者 linting 等等 check scripts 及 CI workflow, 用來自動化攔截 agent 忽視掉的錯誤. 這機制稱之為 `guardrail`, 重點就是要 '自動跑檢查' 就是了.
  - `Coding standards` : 用來規範給 `reviewer agent` 用來 review 的準則.
    - 既存 rule 是否需要被重新分類? 首先, 進行這樣的分類:
      - **mechanical**     : 固定語法樣式 - linter / pre-commit / CI
      - **judgement call** : 得從上下文判斷, 沒有工具可代勞 - 寫 `CODING_STANDARDS.md`, 給 reviewer agent 在 review 時用
        - 用 python 來講, 就像是:
          - 「新 module 的錯誤處理方式要跟同 package 既有的寫法一致」(跨檔案的一致性)
          - 「函式命名要反映 domain 用語, 不要用 process_data、handle 這種泛稱」
          - 「不要為了只有一個實作的東西寫抽象 base class」
  - `Global AGENTS.md` : 放入指導方針(or 自動化檢查). 避免 global context 一開始就太肥大
  - `Tool economy` : 是否用來過於肥大的工具, 但其實是有經濟的替代品?
  - `No-ops` : 檢查 `steering files(導引檔案)` 是否無效, 或者過於肥大
  - `Information access` : 讓 Agent 有權限訪問像是去串 dev server, 或者具備 3rd services 的 read-only 權限
4. 把上述的這些直得優化的地方, 依照重要性交給 user 判斷

## References

SKILL 再次強調, 所有任務都區分成兩個階段: implementation v.s. review

implementation agent `壓力最大 context pressure`

review agent `壓力小` -- 查看 diff; 不需要探索太深的代碼, 也通常不需要 debuging & coding

因此, review agent 需要進行 `imposing coding standards, not the implementation agent`
