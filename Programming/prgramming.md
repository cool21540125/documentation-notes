# reflact

程式在 runtime, 可以存取, 檢測, 和修改它本身狀態 or 行為的一種能力. 也就是說, reflact 就是程式在 runtime 能夠 觀察 並且修改自己的行為

# API First / Design First / Code First

- [A Deep Dive into OpenAPI and Amazon API Gateway](https://www.serverlessguru.com/blog/a-deep-dive-into-openapi-and-amazon-api-gateway)
- 這三種開發流程, 並非相互獨立
  - API First 通常與 Design First 搭配, 因為都要求 API 設計先行
  - Code First 也可融入 API First 之中, 只要 API 被視為核心便可
  - Code First 常被誤解成不需要設計 or 額外撰寫文件, 但其精神是, 設計及摘要註記要融入在程式碼註解中
  - 如果要與非技術人員討論, Design First 能夠更加順暢; 反之則是 Code First

## API First

- 先設計好 API, 作為所有團隊的規格核心
- 比較偏向哲學層面, 強調 API 核心地位
- 適合需要大量協作及複雜任務的專案

## Design First

- 重視 規劃 && 協作 && 標準
- 團隊先用 OpenAPI 寫出 API 文件後, 再來開始產 Code
  - 也就是說, 開始寫程式以前, 需要先規劃和記錄 API spec
  - 通常使用 OpenAPI 作為標準. 要說 OpenAPI 才衍生出 Design First 也不能算錯
- 較偏向、實踐層面
- 適合需要大量協作及複雜任務的專案

## Code First

- 先實作部分基礎 API, 再陸續疊加, 進而生成 API 文件用於跨團隊合作
- API 定義及規範, 多半從 Code Comments 而來
- 重視在設計過程中, 將過程融入 Code, 而非獨立於 Code 之外
- 較偏向、實踐層面, 適合小型且要快速交付的專案
