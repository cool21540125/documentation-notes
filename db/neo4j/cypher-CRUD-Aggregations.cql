// ==================================== 藉由 Node.prop 建立出 Node ====================================
// 原始資料僅有 Movie 的情況下, 由 Movie.language 提煉出 Language, 加以區別 電影使用了哪種語言
// https://graphacademy.neo4j.com/courses/cypher-aggregation/1-understanding-aggregation/01-collect/
MATCH (m:Movie)
UNWIND m.languages AS language
WITH language, collect(m) AS movies
MERGE (l:Language { name: language })
WITH l, movies
UNWIND movies AS m
WITH l, m
MERGE (l)<-[:SPEAKS]-(m)
// to unwind these merges:
// MATCH (x:LANGUAGE) DETACH DELETE x

// endNode() 的用法之一 : 依照關聯 x, 查詢出它所指向的 Node
MATCH (u:User { name: "Misty Williams" })-[x]->()
WITH collect(x) AS ratings
UNWIND ratings AS r
WITH r
WHERE r.rating <= 1
RETURN r.rating AS Rating, endNode(r).title AS Title

// path 的用法之一 : 找出 Person->O->O->O->Actor 中間的 O, 並且 O 為 Movie
MATCH path = (p:Person { name: 'Elvis Presley' })-[*4]-(a:Actor)
WITH nodes(path) AS n
UNWIND n AS x
WITH x
WHERE x:Movie
RETURN DISTINCT x.title

MATCH (m:Movie)<-[:ACTED_IN]-(p:Person)
WITH m, collect(p.name) AS Actors
WHERE size(Actors)<=3
RETURN m.title AS Movie, Actors
// 上為 aggregation 用法 ; 與下面的 subquery 做對照
// WARNING: 對於 5.x 以後, 已經不允許再將 size 放到 CALL 之中做使用
// CALL {
//   MATCH (m:Movie)<-[:ACTED_IN]-(a:Person)
//   WHERE size((m)<-[:ACTED_IN]-()) <= 3
//   RETURN m.title AS Movie, collect(a.name) AS Actors
// }
// RETURN Movie, Actors

// [QUESTION] 如何查詢出, 只有 1 or 2 名演員的電影
// https://graphacademy.neo4j.com/courses/cypher-aggregation/1-understanding-aggregation/02-c-collect/
