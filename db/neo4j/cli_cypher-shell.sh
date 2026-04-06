#!/bin/bash
exit 0
# ----------------------------------------------------------------
PASSWORD=
cypher-shell -u neo4j -p $PASSWORD --address neo4j://localhost:7687

## 
CALL db.schema.visualization() YIELD nodes, relationships
UNWIND relationships AS r
WITH startNode(r) AS s, r, endNode(r) AS e
RETURN labels(s) AS e1, type(r) AS relation, labels(e) AS e2;

## 