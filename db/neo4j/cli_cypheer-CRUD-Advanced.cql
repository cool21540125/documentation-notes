


// ==================================== Variable-length paths (可變長度路徑) ====================================
// 兩個節點之間的關聯長度不確定 - https://neo4j.com/docs/cypher-manual/current/patterns/primer/

// NOTE: 此語法有問題
// 嘗試列出 Nodes 之間 distance < 2
// 但這不僅僅沒考慮到方向, 也會有重複列出的問題
MATCH (()-[link:LINK]-(s) WHERE link.distance <= 2)
RETURN s


// 計算兩車站之間的距離
MATCH (:Station {name: 'Peckham Rye'})-[link:LINK]-+(:Station {name: 'Clapham Junction'})
RETURN reduce(acc = 0.0, l IN link | round(acc + l.distance, 2)) AS totalDistance
// -+ 部分, 指不限定方向; 後續 reduce 則 iterate 所有路經過的節點們逐一計算
// NOTE: 這邊的 LINK 並非特殊用法, 僅為其中一個 Label

// 列出兩車站之間所有車站, 且車站間距小於 2 公里
MATCH (:Station {name: 'Peckham Rye'})
      (()-[link:LINK]-(s) WHERE link.distance <= 2)+
      (:Station {name: 'London Victoria'})
UNWIND s AS station
RETURN station.name AS callingPoint
// 可變長度路徑的問題也可以

// ==================================== APOC library ====================================

// dynamically merge relationships
// 將其中一個 property 利用 AOPC library 建構出一個 Label 並且建立必要關聯 (ex: ACTED_IN_1995), 可用來加速業務邏輯的查詢效能
MATCH (n:Actor)-[r:ACTED_IN]->(m:Movie)
CALL apoc.merge.relationship(n, 
                             'ACTED_IN_' + left(m.released, 4),
                             {},
                             {},
                             m,
                             {}) YIELD rel
RETURN COUNT(*) AS `Number of relationships merged`;