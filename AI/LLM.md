# AI models

Model Type       | Parameters | Size  | Use Case
---------------- | ---------- | ----- | ----------------
all-MiniLM-L6-v2 | 22M        | 90MB  | Embeddings
GPT-3.5          | 175B       | 350GB | Text Generation
GPT-4            | 1.8T       | 3.6TB | Reasoning

https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2

- 知名開源 LLM:
  - LLaMA
  - Mistral
  - Gemma

--------------------------------------------------------------------

```bash
uv pip install sentence-transformers numpy
```

```python
from sentence_transformers import SentenceTransformer
import numpy as np

model = SentenceTransformer('all-MiniLM-L6-v2')

sentences = [
  "Dogs are allowed in the office on Fridays.",
  "Pets can come to work on Furry Fridays.",
  "Remote work policy allows 3 days from home."
]

embeddings = model.encode(sentences)

# similarity between sentences
sim_1_2 = np.dot(embeddings[0], embeddings[1])
sim_1_3 = np.dot(embeddings[0], embeddings[2])
sim_2_2 = np.dot(embeddings[1], embeddings[2])
```


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
