#!/bin/bash
#
#
### ================================================ init Course data - Json Bulk Import ================================================
wget http://media.sundog-soft.com/es8/shakes-mapping.json
curl -H "Content-Type: application/json" -XPUT 127.0.0.1:9200/shakespeare --data-binary @shakes-mapping.json

wget http://media.sundog-soft.com/es8/shakespeare_8.0.json
curl -H "Content-Type: application/json" -XPUT 127.0.0.1:9200/shakespeare/_bulk --data-binary @shakespeare_8.0.json

### ================================================ Example data ================================================

### 建立 movies mapping(僅有 year)
curl -H "Content-Type: application/json" -XPUT 127.0.0.1:9200/movies -d '{
    "mappings": {
        "properties": {
            "year": {"type": "date"}
        }
    }
}'

### 似乎是建立 movies index
curl 127.0.0.1:9200/movies/_mapping | jq

### 塞資料到 movies index (其他欄位會自動推論)
curl -H "Content-Type: application/json" -XPUT 127.0.0.1:9200/movies/_doc/109487 -d '{
    "genre": ["IMAX", "Sci-Fi"],
    "title": "Interstellar",
    "year": 2014
}'

### 似乎是建立 movies index
curl 127.0.0.1:9200/movies/_mapping | jq

### 搜尋 movies
curl -XGET 127.0.0.1:9200/movies/_search | jq

### ================================================ ================================================
# 電影評分 movielens - https://grouplens.org/datasets/movielens/
wget https://files.grouplens.org/datasets/movielens/ml-latest-small.zip # Small Dataset
unzip ml-latest-small.zip && rm ml-latest-small.zip

wget http://media.sundog-soft.com/es8/movies.json
curl -H "Content-Type: application/json" -XPUT 127.0.0.1:9200/_bulk --data-binary @movies.json

# fetch document where id is 109487
curl 127.0.0.1:9200/movies/_doc/109487 | jq

# update title of document to InterstellarNEW whre id is 109487
curl -H "Content-Type: application/json" -XPOST 127.0.0.1:9200/movies/_update/109487 -d '{
    "doc": {
        "title": "InterstellarNEW"
    }
}'

# fetch document where id is 109487
curl 127.0.0.1:9200/movies/_doc/109487 | jq


### 
curl 127.0.0.1:9200/movies/_search?q=Dark

