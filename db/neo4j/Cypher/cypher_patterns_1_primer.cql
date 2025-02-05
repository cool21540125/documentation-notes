// Cypher v5
// Patterns - Primer
// https://neo4j.com/docs/cypher-manual/current/patterns/primer/
// 

// ================================================== data ==================================================
CREATE (n1:Station {name: 'Denmark Hill'}),
(n5:Station {name: 'Battersea Park'}),
(n6:Station {name: 'Wandsworth Road'}),
(n15:Station {name: 'Clapham High Street'}),
(n16:Station {name: 'Peckham Rye'}),
(n17:Station {name: 'Brixton'}),
(n14:Station {name: 'London Victoria'}),
(n18:Station {name: 'Clapham Junction'}),
(p10:Stop {departs: time('22:37'), arrives: time('22:36')}),
(p0:Stop {departs: time('22:41'), arrives: time('22:41')}),
(p2:Stop {departs: time('22:43'), arrives: time('22:43')}),
(p17:Stop {arrives: time('22:50'), departs: time('22:50')}),
(p18:Stop {arrives: time('22:46'), departs: time('22:46')}),
(p19:Stop {departs: time('22:33'), arrives: time('22:31')}),
(p21:Stop {arrives: time('22:55')}),
(p20:Stop {departs: time('22:44'), arrives: time('22:43')}),
(p22:Stop {arrives: time('22:55')}),
(p23:Stop {arrives: time('22:48')}),
(n15)-[:LINK {distance: 1.96}]->(n1)-[:LINK {distance: 0.86}]->(n16),
(n15)-[:LINK {distance: 0.39}]->(n6)<-[:LINK {distance: 0.7}]-(n5)-[:LINK {distance: 1.24}]->(n14), (n5)-[:LINK {distance: 1.45}]->(n18),
(n14)<-[:LINK {distance: 3.18}]-(n17)-[:LINK {distance: 1.11}]->(n1),
(p2)-[:CALLS_AT]->(n6), (p17)-[:CALLS_AT]->(n5), (p19)-[:CALLS_AT]->(n16),
(p22)-[:CALLS_AT]->(n14), (p18)-[:CALLS_AT]->(n18), (p0)-[:CALLS_AT]->(n15), (p23)-[:CALLS_AT]->(n5), (p20)-[:CALLS_AT]->(n1),
(p21)-[:CALLS_AT]->(n14), (p10)-[:CALLS_AT]->(n1), (p19)-[:NEXT]->(p10)-[:NEXT]->(p0)-[:NEXT]->(p2)-[:NEXT]->(p23),
(p22)<-[:NEXT]-(p17)<-[:NEXT]-(p18), (p21)<-[:NEXT]-(p20)
// ================================================== data ==================================================