

// ==================================== Load Data ====================================

// (其中一種方法) 直接從 csv 載入小量資料
LOAD CSV WITH HEADERS FROM 'file:///transactions.csv' AS row
MERGE (t:Transactions {id: row.id})
SET
  t.reference = row.reference,
  t.amount = toInteger(row.amount),
  t.timestamp = datetime(row.timestamp)

// (其中一種方法) neo4j-admin import CLI
// 比較適合用來 importing large data sets (millions/minutes)


// ==================================== Query ====================================

// 查詢計畫
PROFILE MATCH (n:Person) RETURN n

// 查詢所有 nodes
MATCH (n)
RETURN n

// ------ Cypher 查詢, 無法做 property 的參數化查詢, 因此建議增列 Label ------
MATCH (p:US) RETURN p  // Good
MATCH (p:Person) WHERE p.country = 'US' RETURN p // Bad

// ------ 針對既有 Labels 做 refactor, 增加其他 Label ------
MATCH (p:Person) WHERE EXISTS((p)-[ACTED_IN]-()) SET p:Actor
// 只要 Person 曾經從事過 ACTED_IN, 則增加 Actor Label

// ------ 針對所有 Movie 的 languages 特性, 取出後成立新的 Node 並關聯他們; 最後移除 languages 特性 ------
MATCH (m:Movie)
UNWIND m.languages AS lang
WITH lang, collect(m) AS movies
MERGE (l:Language {name: lang})
WITH l, movies
UNWIND movies AS m
WITH l, m
MERGE (m)-[:IN_LANGUAGE]->(l);
MATCH (m:Movie) SET m.languages = null

// 建立 Intermediate Node (解耦)
MATCH (a:Actor)-[r:ACTED_IN]->(m:Movie)
MERGE (x:Role {name: r.role})
MERGE (a)-[:PLAYED]->(x)
MERGE (x)-[:IN_MOVIE]->(m)

// ==================================== Add ====================================

// ==================================== Update ====================================

// ==================================== Delete ====================================

// 移除沒有 label 的 nodes
MATCH (n)
WHERE size(labels(n)) =0
DETACH DELETE n


// ==================================== Condition ====================================

// 若 node 不存在, 則建立
// 若 node 已存在, 則賦予 died
MERGE (p:Person {name: 'Robin Williams'})
ON MATCH SET p.died = 2014
RETURN p

// 若 node 不存在, 建立後, 會賦予 released
// 若 node 已存在, 則賦予 revenue 及 updatedAt
MERGE (m:Movie {title: 'Freaky'})
ON CREATE SET m.released = 2020
ON MATCH SET m.revenue = 15920855 SET m.updatedAt = datetime()
RETURN m



// 