// https://memgraph.com/docs/querying/clauses/optional-match
// OPTIONAL MATCH

// ========================================== raw data ==========================================
MATCH (n)
WHERE n:Person OR n:Country
DETACH DELETE n;

CREATE (c1:Country { name: 'Germany', language: 'German', continent: 'Europe', population: 83000000 });

CREATE (c2:Country { name: 'France', language: 'French', continent: 'Europe', population: 67000000 });

CREATE (c3:Country { name: 'United Kingdom', language: 'English', continent: 'Europe', population: 66000000 });

MATCH (c1), (c2)
WHERE c1.name= 'Germany' AND c2.name = 'France'
CREATE (c2)<-[:WORKING_IN { date_of_start: 2014 }]-(p:Person {name: 'John'})-[:LIVING_IN {date_of_start: 2014}]->(c1);

MATCH (c)
WHERE c.name= 'United Kingdom'
CREATE (c)<-[:WORKING_IN { date_of_start: 2014 }]-(p:Person {name: 'Harry'})-[:LIVING_IN {date_of_start: 2013}]->(c);

MATCH (p1), (p2)
WHERE p1.name = 'John' AND p2.name = 'Harry'
CREATE (p1)-[:FRIENDS_WITH { date_of_start: 2011 }]->(p2);

MATCH (p1), (p2)
WHERE p1.name = 'John' AND p2.name = 'Harry'
CREATE (p1)<-[:FRIENDS_WITH { date_of_start: 2012 }]-(:Person {name: 'Anna'})-[:FRIENDS_WITH {date_of_start: 2014}]->(p2);

MATCH (p), (c1), (c2)
WHERE p.name = 'Anna' AND c1.name = 'United Kingdom' AND c2.name = 'Germany'
CREATE (c2)<-[:LIVING_IN { date_of_start: 2014 }]-(p)-[:LIVING_IN {date_of_start: 2014}]->(c1);

MATCH (n)-[r]->(m)
RETURN n, r, m;

