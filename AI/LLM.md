# AI models

本地運行 LLM 常見的格式:
- GGUF
  - binary 量化模型. Model 可以跑在 CPU 上頭
- MLX
  - Apple 開發的 ML 框架, 專門用在 Apple Silicon, 利用 GPU/NPU 加速

Model Type       | Parameters | Size  | Use Case
---------------- | ---------- | ----- | ----------------
all-MiniLM-L6-v2 | 22M        | 90MB  | Embeddings
GPT-3.5          | 175B       | 350GB | Text Generation
GPT-4            | 1.8T       | 3.6TB | Reasoning

## Qwen3

Models                                    | Platform | Notes
----------------------------------------- | -------- | --------------------------------------------
sgrankin/Qwen3-Embedding-8B-oQ8-fp16      | MLX      | 高品質 8B embedding，體積大
sgrankin/Qwen3-VL-Embedding-8B-oQ8-fp16   | MLX      | 支援 image/text embedding
bsisduck/Qwen3-Embedding-8B-fp16-mlx      | MLX      | 幾乎無量化，品質高但很吃 RAM
redairship/qwen3-embedding-4b-8bit-mlx    | MLX      | 4B 中型模型，效能/品質平衡
redairship/qwen3-embedding-06b-8bit-mlx   | MLX      | 超小模型，適合低資源環境
Zeknes/Qwen3-VL-Embedding-8B-MLX-4bit     | MLX      | VL 多模態 + 4bit 節省記憶體
majentik/Qwen3-Embedding-8B-MLX-8bit      | MLX      | 品質較佳的 8B 版本
majentik/Qwen3-Embedding-4B-MLX-8bit      | MLX      | 常見實用型選擇
majentik/Qwen3-Embedding-8B-MLX-4bit      | MLX      | 低 RAM 版 8B
majentik/Qwen3-Embedding-0.6B-MLX-8bit    | MLX      | 極小型 embedding model
nkamiy/Qwen3-VL-Embedding-8B-8bit-mlx     | MLX      | 多模態 VL embedding
mlx-community/Qwen3-VL-Embedding-2B-8bit  | MLX      | 較輕量的 VL 模型
mlx-community/Qwen3-Embedding-8B-mxfp8    | MLX      | Apple MLX 原生 FP8 格式
mlx-community/Qwen3-Embedding-0.6B-8bit   | MLX      | 超省資源，品質普通
mlx-community/Qwen3-Embedding-8B-4bit-DWQ | MLX      | 極限壓縮版 8B

說明

- `VL`, 表示多模態, 也就是可能的以支援 圖文檢索 / 以圖搜圖
- 量化方式（memory / speed tradeoff）
    - fp16 → 原始精度（最準、最吃資源）
    - 8bit / oQ8 → 主流平衡
    - 4bit / DWQ → 最省記憶體（品質略降）
    - mxfp8 → MLX Apple optimized fast path

--------------------------------------------------------------------

https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2

- 知名開源 LLM:
    - LLaMA
    - Mistral
    - Gemma

--------------------------------------------------------------------

# VectorDB

Vector database 最常用的 indexing algorithms 之一

- Hierarchical Navigable Small World(HNSW) (最常用)
- Inverted File(IVF)
- Locality Sensitive Hashing(LSH)

Embedding 做 document chunking best practices:

- Size Guidelines
  - 200-500 characters 為一個 chunk
  - 50-100 character overlap (做前後文覆蓋)
- Boundary Rules
  - Split at sentences, avoid mid-word breaks
- Quality checks
  - Test with real queries, verify context preservation

Chunking 的主要工作, 是在 context 與 precision 之間取一個平衡
