# AI

https://www.youtube.com/watch?v=AVIKFXLCPY8

- 一個 `接收了成千上萬個參數的函式`, 稱之為 模型
  - 把這些參數找出來的過程, 稱為 training / learning
  - 藉由 訓練資料 來做 training / learning 以後, 去辨識後續的資料, 稱之為 testing / inference
- 一個 `接收了成千上萬個參數的函式`, 又稱之為 類神經網路(Neural Network)

生成式人工智慧

- 人工智慧, 是個目標
  - 生成式人工智慧, 也是目標之一
  - 機器學習, 是種手段
    - 深度學習, 說穿了就是更強大的機器學習
    - 增強式學習(Reinforcement Learning, RL), 也是種機器學習
    - 有些農場文會說, 生成式人工智慧, 也是一種機器學習... (並沒完全正確, 但基本上差不多)
- ChatGPT 其實也是個函式, 接收了上億個參數, 也是個類神經網路
  - ChatGPT 背後的模型為 Transformer, 它是類神經網路的一種
- 語言模型, 是個在做文字接龍的模型
  - 語言模型 是 生成式人工智慧 的一部分
  - 生成, 不一定要用文字, 也可用生波, 影片, 圖片, ...
- 把複雜單位拆解成較小的單元, 按照某種固定的順序依序生成, 稱為 Autoregressive Generation
- 過去的結構化學習, 如今稱為生成式學習

# 語言模型

- LLaMA : Meta 弄出來的
- TAIDE : 國科會弄出來的
- 模型思考 Chain of Thought(CoT), 神奇咒語 (不過這基本上只適用於早期 AI)
  - 某些語言模型, 如果使用者提醒 AI 一步一步來的情況下, 可大幅增加正確率
  - 某些情境之下, 如果使用者題型 AI 這東西對我生涯來說很重要, 則正確率也可增加不少 (對模型情緒勒索)
  - 那有沒有個固定的 Pattern 來施加神奇咒語, 以提高正確性呢?
    - 或許 RL 是一種思路
- Tree of Thoughts, ToT
  - 將複雜問題, 拆解成不同步驟, 每個步驟都有不同的 Solution, 然後依照每個步驟的每個 Solution 去逐一驗證, 直到找到最佳解
- Self-Consistency
  - 針對相同問題, 提問多次(因為 AI 會擲骰子), 然後將最常出現答案的那個選項視為答案
- 還有其他各種不同的 XX of Thought, 基本上都是要語言模型將複雜問題拆解步驟, 各個擊破, 其他還有像是:
  - Algorithm of Thoughts, AoT
  - Graph of Thoughts, GoT
  - Program of Thought, PoT
- 語言模型不適合做什麼:
  - 計算
    - 因為是靠文字接龍.... 數字大一點的乘法就爆掉了
  - 搜尋引擎
    - 因為背後沒有 DataSet 可以查找, 因此會靠著文字接龍湊出看起來合理的答案
- Retrieval Augmented Generation, RAG
  - 因為語言模型背後沒有 DataSet, 因此可自行到 Internet 找到 額外資訊, 連同專業問題, 一起丟給 語言模型 去詢問, 此為 RAG
  - 此機制是在不重新訓練 語言模型 的前提之下, 藉由 額外資訊 的提供, 提升 AI 正確性的很有效的方式


# Claude

```bash
### Claude Desktop 的 mcpServers 設定檔
code ~/Library/Application\ Support/Claude/claude_desktop_config.json
```