//
// Neo4j Index - https://neo4j.com/docs/cypher-manual/current/indexes/
// 
// Neo4j 的 index 有 2 種分類:
//   - Search-performance indexes, 有底下型態:
//       - 1. Range indexes        : (default index) 適用於 most types of predicates. 可作用於 Nodes & Properties
//       - 2. Text indexes         : 對於 STRING value 做 `CONTAINS` && `ENDS WITH` 查詢具備最佳化
//       - 3. Point indexes        : 對於 POINT value 做 distance || within bounding boxes 過濾具備最佳化
//       - 4. Token lookup indexes : (僅適用於 Node Label || Relationship 做優化)
//   - Semantic indexes, 會去檢索 DB data 語意含義 or 上下文, 回應一個 approximation score, 用來表彰資料之間的相似性, 有底下型態:
//       - 5. Full-text indexes : enables searching within the content of STRING properties and for similarity comparisons between query strings and STRING values stored in the database.
//       - 6. Vector indexes    : enables similarity searches and complex analytical queries by representing nodes or properties as vectors in a multidimensional space
// 
// 
// 
// ==================================== index 相關查詢 ====================================

//
SHOW INDEXES;
SHOW INDEXES YIELD *;  // 列出所有欄位

SHOW INDEXES YIELD name, state, type, populationPercent AS pop100
RETURN name, state, type, pop100;


// ==================================== 1. Range index ====================================
// 

CREATE INDEX __node_range_index_name                         FOR (n:Person) ON (n.surname);
CREATE INDEX __rel_range_index_name                          FOR ()-[r:KNOWS]-() ON (r.since);
CREATE INDEX __composite_range_node_index_name               FOR (n:Person) ON (n.age, n.country);
CREATE INDEX __composite_range_rel_index_name                FOR ()-[r:PURCHASED]-() ON (r.date, r.amount);
CREATE INDEX __node_range_index_name           IF NOT EXISTS FOR (n:Person) ON (n.surname);

// 除了上述以外, 仍有 Create a range index using a parameter, 不過無法在 Web Console 裡頭使用 

// ==================================== 2. Text index ====================================
// 用來快速查找 Node 及 Relationship 的 string properties

// ==================================== 3. Point index ====================================
// 具體應用像是經緯度

// ==================================== 4. Token lookup index ====================================
// 用來快速查找 Node labels 及 Relationship types

// ==================================== 5. Full-text index ====================================
// 用來快速查找 Node 及 Relationship 的 1~N 個 string properties, 且支援全文搜尋(Lucene query)

// ==================================== 6. Vector index ====================================

// ********** Delete index **********
DROP INDEX index_name IF EXISTS;
DROP CONSTRAINT index_name;