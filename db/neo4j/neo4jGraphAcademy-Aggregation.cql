// Cypher Aggregations
// https://graphacademy.neo4j.com/courses/cypher-aggregation/1-understanding-aggregation/
// Schema Visualization - https://graphacademy.neo4j.com/courses/cypher-intermediate-queries/1-filtering-queries/images/movie-data-model.png
// 
// Aggregation 核心重點之一 : 降低回傳的筆數
// 
// UNWIND 理解方式 : 將 list 展開成個別的 Elements (也就是 Nodes)
// 
// Aggregation 區分為 Lazy Aggregation 及 Eager Aggregation
//   https://neo4j.com/docs/cypher-manual/current/planning-and-tuning/execution-plans/
// 
// subquery 是用來作 aggregate data 的方式之一
// 

// 以 Actor 為群組, 列出與 Actor 有關的 Movies (會拿到整包 Node)
MATCH (a:Actor)--(m:Movie)
WITH a, collect(m) AS Movies
RETURN a AS Actor, Movies LIMIT 10
// 下面的查詢是比較實際一點的用法 (直接取 Node property)
MATCH (a:Actor)--(m:Movie)
WITH a, collect(m.title) AS Movies
RETURN a.name AS Actor, Movies LIMIT 10

// 
MATCH (a:Person)-[:ACTED_IN]->(m:Movie)<-[:DIRECTED]-(d:Person)
RETURN a.name AS Actor, 
  d.name AS Director,
  count(m) AS Collaborations,
  collect(m.title) AS Movies
// Actor 及 Director 為 Grouping Keys, 計算合拍的電影數量及電影名稱

// 
PROFILE
MATCH (m:Movie {title: 'Jupiter Ascending'})
MATCH (d:Person)-[:DIRECTED]->(m)
MATCH (a:Person)-[:ACTED_IN]->(m)
RETURN m.title AS Title,
  collect(DISTINCT a.name) AS Actors,
  collect(DISTINCT d.name) AS Directors
// 每個 MATCH 都是個 Pipe, output 給下一個 MATCH 作為它的 input
// Movie title 為此查詢的 Group Key

// (效能較不佳)
PROFILE
MATCH (d:Person)-[:DIRECTED]->(m:Movie {title: 'Jupiter Ascending'})<-[:ACTED_IN]-(a:Person)
RETURN m.title AS Title,
  collect(DISTINCT a.name) AS Actors,
  collect(DISTINCT d.name) AS Directors
// (下面效能較好)
PROFILE
MATCH (m:Movie {title: 'Jupiter Ascending'})
MATCH (d:Person)-[:DIRECTED]->(m)
WITH m, collect(d.name) AS Directors
MATCH (a:Person)-[:ACTED_IN]->(m)
RETURN m.title AS Title,
  collect(DISTINCT a.name) AS Actors,
  Directors
// 將 row collect 為 list

//
MATCH (m:Movie)
UNWIND m.languages AS lang
WITH lang, collect(m) AS movies
MERGE (l:Language {name: lang})
WITH l, movies
UNWIND movies AS m
WITH l, m
MERGE (l)<-[:SPEAKS]-(m)
// 第一個 UNWIND 之前 : 將所有 Movie 的 languages, 全部取出來作為 list, 暫時命名為 lang
// WITH MERGE : 將上述 lang 製作成 Language Label 的 Node, 命名為 l
// WITH UNWIND : 將 movies list 展開成單獨的 Nodes (不然原本是 list, 沒辦法拿來做 MERGE)
// 製作出一堆 Language Nodes 以後的恢復方式:
// MATCH (x:Language) DETACH DELETE x

//
MATCH (u:User {name: "Misty Williams"})-[x]->()
WITH collect(x) AS ratings
UNWIND ratings AS r
WITH r WHERE r.rating <= 1
RETURN r.rating AS Rating,
  endNode(r).title AS Title
// endNode(r) 用來取得 r 的終端節點 (也就是此關聯指向的節點), 也就是此評分的對象電影 (電影拿了幾分啦)

//
MATCH path = (p:Person {name: 'Elvis Presley'})-[*4]-(a:Actor)
WITH nodes(path) AS n
UNWIND n AS x
WITH x WHERE x:Movie
RETURN DISTINCT x.title
// 回傳 a list of all nodes in a path

// 搜尋演員數量 <= 3 的電影
PROFILE
MATCH (m:Movie)<-[:ACTED_IN]-(a:Person)
WITH m, collect(a.name) AS Actors
WHERE size(Actors) <= 3
RETURN m.title AS Movie, Actors
// (上面寫法可以改善)
// 但官方原始教學使用的是舊版 Cypher 的範例, 目前 5.x 已不支援(及 DEPRECATED) CALL, size 等寫法)
// PROFILE
// MATCH (m:Movie)<-[:ACTED_IN]-(a:Person)
// WITH m, count(a) AS cnt
// WHERE cnt >= 3
// MATCH (m)<-[:ACTED_IN]-(a:Person)
// RETURN m.title, collect(a.name) AS Actors
// 上面我自己改寫以後反而更慢了@@... 而且應該是錯誤的!!
