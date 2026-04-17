# AI Agent

與 agent 溝通時, 務必永遠留意到:

- context
- model
- prompt
- tools
- flow

## AI 近年來演進 ~ 2026Q2

- Prompt Engineering
  - 模型有沒有聽懂
- Context Engineering
  - 模型有沒有拿到正確訊息
- Harness Engineering
  - 模型能不能持續交付有品質的產出

> LangChain 工程師給了一個定義:
> 
> Agent = Harness + Model
> 
> Harness = Agent - Model
 
- Agent 團隊內部一位很優秀的人員
- Harness 團隊的工作流程及業務邏輯
- Model 很優秀的人, 但不熟團隊運作


# RAG 架構 - 例外處理實作範例

```python
def get_reply(query: str):
  try:
    # Try full RAG pipeline
    return rag_pipeline(query)
  except VectorDBError:
    # Fallback to keyword search
    return keyword_search(query)
  except LLMError:
    # Return retrieved chunks directly
    return format_retrieved_chunks(query)
  except EmbeddingError:
    # Use simple text matching
    return text_search(query)
  except Exception:
    return "Service temporarily unavailable. Please try again later."
```

```mermaid
graph TD
subgraph "Container Orchestration"
  subgraph "Data Layer"
    VecDB[(VectorDB)]
    Redis[(Redis)]
    PG[(PostgreSQL)]
  end

  subgraph "RAG Pipeline Layer"
    Query[Query Service]
    Chunk[Chunking]
    Embed[Embeddings]
    Ret[Retrieval]
    Gen[Generate]
    Aug[Augment Service]
    Route[Routing]
    Cache[Caching]
  end

  subgraph "Application Layer"
    UI[User Interface System]
    Mobile[Mobile Service]
    Admin[Admin Service]
  end



  subgraph "Monitoring Stack"
    Grafana
    Prometheus
    Jaeger
    Docs[Private Policy Documents]
  end
end
```