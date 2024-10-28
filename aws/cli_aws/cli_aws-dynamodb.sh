#!/bin/bash
exit 0

# ---------------------------

### Create Table
aws dynamodb create-table \
  --table-name Movies \
  --attribute-definitions \
  AttributeName=year,AttributeType=N \
  AttributeName=title,AttributeType=S \
  --key-schema \
  AttributeName=year,KeyType=HASH \
  AttributeName=title,KeyType=RANGE \
  --billing-mode PROVISIONED \
  --provisioned-throughput ReadCapacityUnits=2,WriteCapacityUnits=1
# 會回傳一大包的執行結果
# 不想燒錢的話留意免費額度
# 也可藉由使用 「--endpoint-url http://localhost:8000」來指向 local DynamoDB

### new item
aws dynamodb put-item \
  --table-name Movies \
  --item '{"year": {"N": "1900"}, "title": {"S": "Example 1"}}'
# for DynamoDB online, tablename 為 case-senstive
# for DynamoDB local, tablename 為 case-insenstive

### Query table
# 使用 KeyConditionExpression (也就是 PK 啦) 來查詢特定一筆
aws dynamodb query \
  --table-name Movies \
  --projection-expression "title" \
  --key-condition-expression "#y =:yr" \
  --expression-attribute-names '{"#y": "year"}' \
  --expression-attribute-values '{":yr": {"N": "1985"}}'
# --projection-expression, 告知需要回傳的欄位
# year 是 DynamoDB 的保留字... (UNKNOWN)
# ----- example query result -----
#{
#    "Items": [
#        {
#            "title": {
#                "S": "Back to the Future"
#            }
#        },
#        {
#            "title": {
#                "S": "Pee-wee's Big Adventure"
#            }
#        },
#        {
#            "title": {
#                "S": "The Breakfast Club"
#            }
#        },
#        {
#            "title": {
#                "S": "The Goonies"
#            }
#        }
#    ],
#    "Count": 4,
#    "ScannedCount": 4,
#    "ConsumedCapacity": null
#}
# ----- example query result -----

### 使用 Scan (慎用 scan!!)
aws dynamodb scan \
  --table-name Movies \
  --filter-expression "title=:name" \
  --expression-attribute-values '{":name": {"S": "Back to the Future"}}' \
  --return-consumed-capacity 'TOTAL'
# max return to 1MB, 會做 pagination
# UNKNOWN

###
aws dynamodb scan \
  --table-name MovieHistoryProject \
  --filter-expression 'Genre=:g' \
  --expression-attribute-values '{":g": {"S": "Horror"}}'

###
aws dynamodb create-table \
  --table-name MovieHistoryProject \
  --attribute-definitions \
  AttributeName=Year,AttributeType=N \
  AttributeName=Title,AttributeType=S \
  AttributeName=Genre,AttributeType=S \
  --key-schema \
  AttributeName=Year,KeyType=HASH \
  AttributeName=Title,KeyType=RANGE \
  --provisioned-throughput \
  ReadCapacityUnits=1,WriteCapacityUnits=1 \
  --local-secondary-indexes '[{
            "IndexName": "GenreIndex",
            "KeySchema": [{
                "AttributeName": "Year",
                "KeyType": "HASH"
            },
            {
                "AttributeName": "Genre", 
                "KeyType": "RANGE"
            }],
            "Projection": {
                "ProjectionType": "INCLUDE", 
                "NonKeyAttributes": ["Director", "Year"]
            }
        }]' \
  --endpoint-url http://localhost:8000
#

### 針對已存在的 Table 增加 GSI (注意! 增/刪 GSI 都是使用 update-table)
aws dynamodb update-table \
  --table-name MovieHistoryProject \
  --attribute-definitions AttributeName=Genre,AttributeType=S \
  --global-secondary-index-updates '[{
        "Create": {
            "IndexName": "Genre-index",
            "KeySchema": [{"AttributeName": "Genre", "KeyType": "HASH"}],
            "ProvisionedThroughput": {"ReadCapacityUnits": 1, "WriteCapacityUnits": 1},
            "Projection": {"ProjectionType": "ALL"}
        }
    }]'
# ProjectionType 可挑選 ALL, INCLUDE, KEYS_ONLY. 每種佔用的儲存容量不相同(左大右小)

### describe table
aws dynamodb describe-table \
  --table-name MovieHistoryProject

###
aws dynamodb query \
  --table-name MusicCollection \
  --index-name AlbumTitleIndex \
  --key-condition-expression "Artist = :v_artist and AlbumTitle = :v_title" \
  --expression-attribute-values '{":v_artist": {"S": "Acme Band", ":v_title": {"S": "Songs About Life"}}}'
# 使用 `AlbumTitleIndex` 這個 Secondary Index 做 Query
# AlbumTitle 則為 sort key

### 使用 FilterExpression 查詢
aws dynamodb scan \
  --table-name Movies \
  --filter-expression "title = :t" \
  --expression-attribute-values '{ ":t": {"S":"Como agua para chocolate"}}' \
  --endpoint-url http://localhost:8000
# FilterExpression 為 client-side filtering

### 取所有 items, 不過藉由 page-size 來避免 timeout (UNKNOWN)
aws dynamodb scan \
  --table-name Movies \
  --page-size 1 \
  --endpoint-url http://localhost:8000

###
aws dynamodb scan \
  --table-name Movies \
  --max-items 2 \
  --starting-token eyJFeGNsdXNpdmVTdGFydEtleSI6IG51bGwsICJib3RvX3RydW5jYXRlX2Ftb3VudCI6IDF9 \
  --endpoint-url http://localhost:8000
# --starting-token : aws s3 xxxx 也有這樣的概念, 可理解成從某一筆資料起算 (並無 --page=xx 的指令)

### 如果遇到大量高頻使用 DDb 的話, 需要留意 DynamoDB quota 問題
aws dynamodb describe-limits

###
