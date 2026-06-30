# FastMCP

FastMCP servers 有 3 種 components 用來因應不同用途:

- **Tools** : functions that clients invoke to perform actions or access external systems.
- **Resources** : expose data that clients can read — passive data sources rather than invocable functions.
- **Prompts** : reusable message templates that guide LLM interactions.


---

- Server 若將來有多台, ALB 需要使用 ALB sticky session
- TG health check: MCP Server 加一個 /health 給 ALB 探測
- FactMCP tags
    - mcp.tool 可以標記 `tags={"public"}`
- Hiding Parameters from the LLM 章節 https://gofastmcp.com/servers/tools#hiding-parameters-from-the-llm
    - 在講說, 像是 order_id 及 user_id 這一類的查詢, 應該額外做一層依賴, Model 訪問 MCP 的時候, 應該從 user_id 是誰, 有啥權限, 然後進行可以訪問到的 details


## FastMCP Developer

- FastMCP Apps - https://gofastmcp.com/apps/overview
  - 預設 Server 只會回傳文字給 Client
  - App 則可讓 Server tool 可以回傳文字以外的可互動式 UI (圖表, 表單, 儀表板, ...).
  - 最終 user 看到的畫面, 則依賴於 Client host(e.g.: Claude Desktop) 是否有支援呈現方式
    - NOTE: MCP 規格當中會把像是 Claude Desktop 稱之為 **host**. host 內部會包含一個 MCP client 的實作.
- FastMCP Clients - https://gofastmcp.com/clients/client
  - 可以自幹 MCP Client UI. 但像是如果從頭到尾只有使用 Claude Desktop, 那麼就沒必要理會這章節
