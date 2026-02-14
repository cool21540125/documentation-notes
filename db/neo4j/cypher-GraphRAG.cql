//
// db.index.vector.queryNodes - 使用 kNN 方式查 Vector Index, 列出最相似 nodes
//
// NOTE: 若使用到 genai.vector.xxx 的時候, Neo4j DB instance 需要安裝 `Gen AI` plugin
//
// 從非結構化文字段落取得關鍵詞, 存成新的 Graph Node 並且建立關聯 (較為進階)
// https://graphacademy.neo4j.com/courses/llm-vectors-unstructured/3-unstructured-data/6-extract-topics/
//


//
// 針對 Node attribute,建立 Vector Index (用於加速 Node 的 embedding attributes 的搜尋)
//
CREATE VECTOR INDEX index_name IF NOT EXISTS
FOR (n:LabelName) ON (n.propertyName)
OPTIONS { indexConfig: {
 `vector.dimensions`: 1536,
 `vector.similarity_function`: 'cosine'
}};

// 
// 直接指定 Node id, 列出與它 embedding_attr 最相似的 10 個 Nodes (並且藉由 index_name 這個 Vector Index)
//
MATCH (n:LabelName {id: "abcd123456"})
CALL db.index.vector.queryNodes('index_name', 10, n.embedding_attr)
YIELD node, score
// other conditions
RETURN node, score;

//
// 針對用戶提問的原始文字 raw_user_prompt_query_message 做 embedding 以後, 查出 10 最相似 nodes (by using OpenAI)
//
WITH genai.vector.encode("raw_user_prompt_query_message", "OpenAI",
  {
    token: "sk-xxx"}) AS userEmbedding
CALL db.index.vector.queryNodes('index_name', 10, userEmbedding)
YIELD node, score
// other conditions
RETURN node.text, score;

// (同上) 這一段屬於程式碼遷入查詢語句的寫法
//
//   result = graph.query("""
//     CALL db.index.vector.queryNodes('chunkVector', 6, $embedding)
//     YIELD node, score
//     RETURN node.text, score
//   """,  
//     {"embedding": embedding}
//   )
//
// // 適用於 user 提問, 將提問問句做 embedding 以後得到 text_embedding
// // 由 index_name 這個 Vector Index 加速查找與 user 提問最相似的 10 個 labelName node 及 score

// 
SHOW INDEX WHERE type = "VECTOR";
