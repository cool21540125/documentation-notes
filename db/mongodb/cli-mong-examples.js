// mongosh 取得 mongo shell

// -------------------------------- Example --------------------------------
// 單一 Document內的子元素, 可能有上百個, 可用 Child-Referencing ( `資料主角`紀錄`子文件`位置 )

//  模擬資料
db.parts.insertMany([
    {"_id": "q1", "qty":94,  "cost": 0.94, "price": 3.99, "address": "tw" },
    {"_id": "q2", "qty":23,  "cost": 0.38, "price": 1,    "address": "cn" },
    {"_id": "q3", "qty":322, "cost": 1.58, "price": 400,  "address": "jp" }
]);
db.main.insertOne({"_id": "tony", "age": 30,"has": [ "q1", "q2", "q3" ]});

// 查詢方式
owner = db.main.findOne({_id: 'tony'});
qry = db.parts.find({_id: { $in:  owner.has }});
// { "_id" : "q1", "qty" : 94, "cost" : 0.94, "price" : 3.99, "address" : "tw" }
// { "_id" : "q2", "qty" : 23, "cost" : 0.38, "price" : 1, "address" : "cn" }
// { "_id" : "q3", "qty" : 322, "cost" : 1.58, "price" : 400, "address" : "jp" }


////// -------------------------------- Example --------------------------------
// 單一 Document內的子元素, 可能有巨量級資料, 可用 Parent-Referencing ( 每筆`子文件`紀錄`資料主角`位置 )

// 模擬資料
db.hosts.insertOne({_id:"ObjectID('AAAB')",name:'goofy.example.com',ipaddr:'127.66.66.66'});
db.logmsg.insertOne({time:new Date(),message:'cpuisonfire!',host:"ObjectID('AAAB')"});

// 尋找方式
host = db.hosts.findOne({ipaddr: '127.66.66.66'});
qry = db.logmsg.find({host: host._id}).toArray();
// [
//         {
//                 "_id" : ObjectId("5a214ed99dc338934f58000c"),
//                 "time" : ISODate("2017-12-01T12:45:13.206Z"),
//                 "message" : "cpuisonfire!",
//                 "host" : "ObjectID('AAAB')"
//         }
// ]


////// -------------------------------- Example --------------------------------
// aggregate + update
// Aggregation with update in mongoDB - https://stackoverflow.com/questions/19384871/aggregation-with-update-in-mongodb

// 1. 
db.agg.insertMany([{ 
    "_id": ObjectId("525c22348771ebd7b179add8"), 
    "cust_id": "A1234", 
    "score": 500, 
    "status": "A",
    "clear": "No"
},{ 
    "_id": ObjectId("525c22348771ebd7b179add9"), 
    "cust_id": "A1234", 
    "score": 1600, 
    "status": "B",
    "clear": "No"
}]);

// 2.
db.agg.find();
//{ "_id" : ObjectId("525c22348771ebd7b179add8"), "cust_id" : "A1234", "score" : 500, "status" : "A", "clear" : "No" }
//{ "_id" : ObjectId("525c22348771ebd7b179add9"), "cust_id" : "A1234", "score" : 1600, "status" : "B", "clear" : "No" }

// 3a.
var gg = db.agg.aggregate([
    {'$match': { '$or': [{'status': 'A'}, {'status': 'B'}]}},
    {'$group': {'_id': '$cust_id', 'total': {'$sum': '$score'}}},
    {'$match': {'total': {'$gt': 2000}}}
]);

// 3b.
gg.forEach(function(x) {
        db.agg.update({'cust_id': x._id}, {'$set': {'clear': 'YES'}}, {'multi': true});
    }
);

// result
db.agg.find();
//{ "_id" : ObjectId("525c22348771ebd7b179add8"), "cust_id" : "A1234", "score" : 500, "status" : "A", "clear" : "YES" }
//{ "_id" : ObjectId("525c22348771ebd7b179add9"), "cust_id" : "A1234", "score" : 1600, "status" : "B", "clear" : "YES" }




// -------------------------------- Example --------------------------------
// 多對一反正規化

// 模擬資料
db.products.insertOne({_id:'left-handedsmokeshifter',manufacturer:'AcmeCorp',catalog_number:1234,parts:[{id:"ObjectID('F17C')",name:'fanbladeassembly'},{id:"ObjectID('D2AA')",name:'powerswitch'}]});
db.parts.insertMany([{_id:"ObjectID('AAAA')",name:'#4grommet'},{_id:"ObjectID('F17C')",name:'fanbladeassembly'},{_id:"ObjectID('D2AA')",name:'powerswitch'}])

// 以 products.parts.id為清單, 找到對應的 parts._id 的詳細資訊, 運用的技巧稱為 Application-level Join
product = db.products.findOne({catalog_number: 1234});
part_ids = product.parts.map( function(doc) { return doc.id } );
product_parts = db.parts.find({_id: { $in : part_ids } } ).toArray();



//////