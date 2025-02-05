// Intermediate Cypher Queries
// https://graphacademy.neo4j.com/courses/cypher-intermediate-queries/
// Schema Visualization - https://graphacademy.neo4j.com/courses/cypher-intermediate-queries/1-filtering-queries/images/movie-data-model.png
// 2025/01/29

// Testing Equality
MATCH (p:Director)-[r:DIRECTED]->(m:Movie{year:2000})-[g:IN_GENRE]->(ge:Genre{name:'Horror'})
RETURN COUNT(m.title);

// 可使用 .year.month.day 來將 timestamp property 做 .年.月.日 轉換
MATCH (p:Actor:Director)
WHERE 1950 <= p.born.year <= 1959
RETURN COUNT(p);

// 
MATCH (m:Movie)
WHERE 'German' IN m.languages
RETURN m;

// 如果要搜尋 Node 的 property, 並且在意他的大小寫, 則應使用 full-text schema indexes
MATCH (m:Movie)
WHERE toLower(m.title) STARTS WITH 'life is'
RETURN COUNT(m.title);
// 上述範例查詢速度慢(因為會做 scan)

// 
PROFILE MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE p.name = 'Tom Hanks' AND EXISTS {(p)-[:DIRECTED]->(m)}
RETURN m.title;

// Person 同時 DIRECTED 並且 ACTED_IN 的電影名稱 (已經是最佳寫法)
PROFILE MATCH (p:Person)-[:DIRECTED]->(m:Movie)<-[:ACTED_IN]-(p)
WHERE p.name  = 'Tom Hanks'
RETURN m.title;

// Person 只有 DIRECTED, 但沒有 ACTED_IN 的電影名稱 (已經是最佳寫法)
MATCH (p:Person)-[:DIRECTED]->(m:Movie)
WHERE p.name = 'Rob Reiner' AND NOT exists {(p)-[:ACTED_IN]->(m)}
RETURN DISTINCT m.title;

// multiple Pattern MATCH
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)<-[:DIRECTED]-(d:Person)
WHERE m.year > 2000
RETURN a.name, m.title, d.name
// (上面查詢效能, 等同於下面查詢) 
MATCH (p:Person)-[:ACTED_IN]->(m:Movie), (m)<-[:DIRECTED]-(d:Person)
WHERE m.year > 2000
RETURN a.name, m.title, d.name
// (上面查詢的效能, 優於下面查詢) 使用單一個 MATCH 的效能會比多個 MATCH 效能還要好
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE m.year > 2000
MATCH (m)<-[:DIRECTED]-(d:Person)
RETURN a.name, m.title, d.name

// 找到與 Kiss Me Deadly 相同類型的電影, 以及共同演員(nullable, 因為是 OPTIONAL MATCH)
MATCH (m:Movie) WHERE m.title = "Kiss Me Deadly"
MATCH (m)-[:IN_GENRE]->(g:Genre)<-[:IN_GENRE]-(rec:Movie)
OPTIONAL MATCH (m)<-[:ACTED_IN]-(a:Actor)-[:ACTED_IN]->(rec)
RETURN rec.title, a.name

// (1140筆) 列出所有 Film-Noir 類型的電影, 以及所有評論過的 User
MATCH (m:Movie)-[:IN_GENRE]->(g:Genre)
WHERE g.name = 'Film-Noir'
MATCH (m)<-[:RATED]-(u:User)
RETURN m.title, u.name
// (比較上下)
// (1152筆) 列出所有 Film-Noir 類型的電影, 以及所有評論過的 User (若無評論, 則顯示 null)
MATCH (m:Movie)-[:IN_GENRE]->(g:Genre)
WHERE g.name = 'Film-Noir'
OPTIONAL MATCH (m)<-[:RATED]-(u:User)
RETURN m.title, u.name

// 僅回傳 property values (而非整個 Node JSON, 且無 Label 及 Id)
MATCH (p:Person)
WHERE p.name CONTAINS "Thomas"
RETURN p { .* } AS person;
// 指定僅需要的 property values
MATCH (p:Person)
WHERE p.name CONTAINS "Thomas" AND p.born IS NOT null
RETURN p { .name, manual: true } AS person,
date().year - p.born.year AS ageThisYear;

// Case 用法
MATCH (m:Movie)<-[:ACTED_IN]-(p:Person)
WHERE p.name = 'Henry Fonda'
RETURN m.title AS movie,
CASE 
  WHEN m.year < 1940 THEN 'legacy'
  WHEN 1940 <= m.year < 2000 THEN 'oldies'
  ELSE '20-Centry'
END AS movieEra;
// Case 用法
MATCH (m:Movie)<-[:ACTED_IN]-(p:Person)
WHERE p.name = 'Charlie Chaplin'
RETURN m.title AS movie,
CASE
  WHEN m.runtime < 120 THEN 'Short'
  ELSE 'Long'
END AS runTime

// ---------------------------- Aggregation ----------------------------
// Cypher 使用 Aggregation 不需要 Group By; 欄位使用了 COUNT, 其他欄位自動視為 Group By
// 
// COUNT(n) 僅計算 non-null
// COUNT(*) 包含 null
// 

// 此為 Eager Aggregation (依舊不是很明白這啥...)
// (a 扮演 & d 指導拍攝)了相同的 numMovies 部電影 (與 a 及 d 有關聯的電影數量)
// a(扮演) 與 d(指導) 共演的電影數量
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)<-[:DIRECTED]-(d:Person)
RETURN a.name, d.name, COUNT(*) AS numMovies
ORDER BY numMovies DESC

// (list 用法) 自行定義 list 的回傳欄位
MATCH (p:Person)
RETURN p.name, [p.born, p.died] AS lifeTime
LIMIT 10

// (collect 用法) collect 用來將 values aggregate 成 list
// 某演員, 總共演過多少部電影 && 哪些電影(list)
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
RETURN p.name AS actor,
  COUNT(*) AS total,
  collect(m.title) AS movies
ORDER BY total DESC LIMIT 10;
// collect 其實就是指, 將此結果弄成 list

// 