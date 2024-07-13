# MongoDB

```sh
$ mongo --version
# MongoDB shell version v3.6.3
```

```sh
$ mongo <host>:<port>/<db name> -u <id> -p <pd>
```



# Example

- [example for nodejs using mongodb](https://gist.github.com/dolphin278/5445957)


counter_simulate_data.js
```js
/* 
    Date: 2018/05/04

    Dependancy:
        npm install mongodb

    Edition: v8.11.1

    Program: 
        每 freq 豪秒, 塞1筆模擬的 Counter data到 <dbName> 裡的 <collName>
        資料格式如下:
        {
            "_id": ObjectID(),          MongoDB ID
            "v": <int>,                 亂數產生 - 資料值(累計值) 
            "dt": <datetime>,           資料來源時間(毫秒) ISODate
            "src": <string>             資料來源的 感應器名稱 or 感應器ID
            "type": "co",               Counter以 "co" 表示
        }
*/

// 參數 ********************************************************

var uid = '';
var upd = '';
var host = "127.0.0.1";
var port = 27017;
var dbName = "test";
var collName = "counter";
var src = 'co1';                    // 資料來源
var freq = 500;                     // 每筆 「freq/1000 」秒

// 程式開始 ******************************************************

var MongoClient = require('mongodb').MongoClient;

if (uid === '' && upd === '') {
    var url = "mongodb://" + host + ":" + port + "/";
} else {
    var url = "mongodb://" + uid + ":" + upd + "@" + host + ":" + port + "/";
}

MongoClient.connect(url, function(err, db) {
    if (err) throw err;
    var dbo = db.db(dbName);
    dbo.collection(collName).deleteMany({'src': src, 'type': 'co'});
    dbo.collection(collName, function(err, collName) {
        var q = 0;              // 累計 counter值
        var i = 0;              // 第幾筆
        var data;

        setInterval(function() {
            q += Math.round(Math.random() * 3);
            data = {
                q: q,
                dt: new Date(),
                src: src,
                type: 'co',
            }

            collName.insert(data, function(err, doc) {
                i++;
                console.log('第 ' + i + ' 筆\n', data);
            });
        }, freq * 1);
    });
});
```


insertRandomTimeData.js
```js
/* 說明
    Date: 2018/05/04

    Dependancy:
        npm install mongodb
        npm install gaussian

    Version: v8.11.1

    Program: 
        每 freq 豪秒, 塞1筆模擬資料到 dbName 裡的 collName
        模擬觸發事件送資料到資料庫的情況
*/

// 參數 ********************************************************

var uid = '';
var upd = '';
var host = "127.0.0.1";
var port = 27017;
var dbName = "test";
var collName = "randTime";

// 亂數模擬參數---
var mean = 10;
var variance = 10;

// 程式開始 ******************************************************

var MongoClient = require('mongodb').MongoClient;
var gaussian = require('gaussian');

if (uid === '' && upd === '') {
    var url = "mongodb://" + host + ":" + port + "/" + dbName;
} else {
    var url = "mongodb://" + uid + ":" + upd + "@" + host + ":" + port + "/" + dbName;
}

var dist = gaussian(mean, variance);

function onCollection(err, collection) {
    var itemsSent = 0;
    var time_period;

    function call_me() {
        collection.insert({
            dt: new ISODate(),

        }, function(err, doc) {
            itemsSent++;
            console.log('items sent', itemsSent + '.');
        }); 

        setTimeout(call_me, 1000 * dist.ppf(Math.random())); // 平均 mean秒, 變異數 variance秒, 塞資料
    } 

    call_me();
}

function onConnected(err, db) {
    db.collection(collName, onCollection);
}

MongoClient.connect(url, onConnected);
```


insertSimulateData.js
```js
/* 說明
    date: 2018/05

    Dependancy:
        mongodb

    Program:
        每 freq 豪秒, 塞1筆模擬資料到 dbName 裡的 collName
*/

// 參數 ********************************************************
var uid = '';
var upd = '';
var host = "127.0.0.1";
var port = 27017;
var dbName = "test";
var collName = "test";
var freq = 1;               // 每筆 「freq/1000 」秒

// 程式開始 ******************************************************

var MongoClient = require('mongodb').MongoClient;

if (uid === '' && upd === '') {
    var url = "mongodb://" + host + ":" + port + "/" + dbName;
} else {
    var url = "mongodb://" + uid + ":" + upd + "@" + host + ":" + port + "/" + dbName;
}

MongoClient.connect(url, function(err, db) {
    db.collection(collName, function(err, collection) {
        var itemsSent = 0;

        setInterval(function() {
            collection.insert({
                value: Math.round(Math.random() * 100),
                dt: new Date().toLocaleString()
            }, function(err, doc) {
                itemsSent++;
                // console.log('items sent', itemsSent);
            });
        }, freq * 1);
    });
});
```
