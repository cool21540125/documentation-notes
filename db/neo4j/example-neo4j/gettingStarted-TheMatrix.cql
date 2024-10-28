CREATE (TheMatrix:Movie { title:'The Matrix', released:1999, tagline:'Welcome to the Real World' })

CREATE (Keanu:Person { name: 'Keanu Reeves', born: 1964 })

CREATE
(Keanu) - [:ACTED_IN { roles:['Neo'] }] -> (TheMatrix),
(Carrie)-[:ACTED_IN { roles:['Trinity'] }]->(TheMatrix),
(Laurence)-[:ACTED_IN{ roles:['Morpheus'] }]->(TheMatrix),
(Hugo)-[:ACTED_IN{ roles:['Agent Smith'] }]->(TheMatrix),
(LillyW)-[:DIRETED]->(TheMatrix),
(LanaW)-[:DIRECTED]->(TheMatrix),
(JoelS)-[:PRODUCED]->(TheMatrix)

//
CREATE (ee:Person { name:'Emil', scope:'book' })
<-[:KNOWS]-(jj:Person { name:'Jim', scope:'book' })
-[:KNOWS]->(ii:Person { name:'Ian', scope:'book' })
-[:KNOWS]->(ee)

MATCH (jj:Person { name:'Jim' })-[:KNOWS]->(bb)-[:KNOWS]->(cc)
RETURN bb, cc

// 刪除資料
MATCH (p:Person)
WHERE (p.name <> 'Tony')
DETACH DELETE p

// 